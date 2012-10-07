//
//  LevelCompletedDialog.m
//  Beezle
//
//  Created by KM Lagerstrom on 09/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LevelCompletedDialog.h"
#import "Game.h"
#import "GameplayState.h"
#import "LevelLayout.h"
#import "LevelLayoutCache.h"
#import "LevelOrganizer.h"
#import "LevelRatings.h"
#import "LevelSession.h"
#import "RateLevelState.h"
#import "PlayState.h"
#import "GameStateUtils.h"
#import "SoundManager.h"
#import "LevelSelectMenuState.h"

static const int POLLEN_COUNT_PER_FLYING_POLLEN = 4;

@interface LevelCompletedDialog()

-(void) createFlowerSprites;

@end

@implementation LevelCompletedDialog

-(id) initWithGame:(Game *)game andLevelSession:(LevelSession *)levelSession
{
	if (self = [super initWithInterfaceFile:@"LevelCompletedDialog.ccbi"])
	{
		_game = game;
        _levelSession = levelSession;

		[_titleSprite setScale:0.1f];
		[_titleSprite runAction:[CCEaseBounceOut actionWithAction:[CCScaleTo actionWithDuration:0.7f scale:1.0f]]];

		NSString *pollenString = [NSString stringWithFormat:@"%d", [levelSession totalNumberOfPollen]];
		_pollenLabel = [[CCLabelAtlas alloc] initWithString:pollenString charMapFile:@"numberImages-s.png" itemWidth:15 itemHeight:18 startCharMap:'/'];
		[_pollenLabel setAnchorPoint:CGPointZero];
		[_pollenLabel setPosition:[_pollenLabelPosition position]];
		[self addChild:_pollenLabel];

		[self createFlowerSprites];
	}
	return self;
}

-(void) dealloc
{
	[_pollenLabel release];
	[_flowerSprite1 release];
	[_flowerSprite2 release];
	[_flowerSprite3 release];

	[super dealloc];
}

-(void) createFlowerSprites
{
	LevelLayout *layout = [[LevelLayoutCache sharedLevelLayoutCache] levelLayoutByName:[_levelSession levelName]];

	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Interface.plist"];

	_flowerSprite1 = [[CCSprite alloc] initWithSpriteFrameName:@"Flower/Flower-Screen-dim.png"];
	[_flowerSprite1 setPosition:[_flowerSprite1Position position]];
	[self addChild:_flowerSprite1];

	_flowerSprite2 = [[CCSprite alloc] initWithSpriteFrameName:@"Flower/Flower-Screen-dim.png"];
	[_flowerSprite2 setPosition:[_flowerSprite2Position position]];
	[self addChild:_flowerSprite2];

	_flowerSprite3 = [[CCSprite alloc] initWithSpriteFrameName:@"Flower/Flower-Screen-dim.png"];
	[_flowerSprite3 setPosition:[_flowerSprite3Position position]];
	[self addChild:_flowerSprite3];

	if ([layout pollenForTwoFlowers] == 0 ||
		[layout pollenForThreeFlowers] == 0)
	{
		return;
	}

	int numberOfFlowers = [_levelSession totalNumberOfFlowers];
	int pollenForFlower1 = 0;
	int pollenForFlower2 = 0;
	int pollenForFlower3 = 0;
	if (numberOfFlowers == 1)
	{
		pollenForFlower1 = [_levelSession totalNumberOfPollen];
	}
	else if (numberOfFlowers == 2)
	{
		pollenForFlower1 = (int)([_levelSession totalNumberOfPollen] / 2.0f);
		pollenForFlower2 = [_levelSession totalNumberOfPollen];
	}
	else
	{
		pollenForFlower1 = (int)([_levelSession totalNumberOfPollen] / 3.0f);
		pollenForFlower2 = 2 * pollenForFlower1;
		pollenForFlower3 = [_levelSession totalNumberOfPollen];
	}

	int i = 0;
	int currentPollenCount = 0;
	while (currentPollenCount < [_levelSession totalNumberOfPollen])
	{
		int flowerIndex;
		if (currentPollenCount < pollenForFlower1)
		{
			if (pollenForFlower1 - currentPollenCount < POLLEN_COUNT_PER_FLYING_POLLEN)
			{
				currentPollenCount = pollenForFlower1;
			}
			else
			{
				currentPollenCount += POLLEN_COUNT_PER_FLYING_POLLEN;
			}
			flowerIndex = 0;
		}
		else if (currentPollenCount < pollenForFlower2)
		{
			if (pollenForFlower2 - currentPollenCount < POLLEN_COUNT_PER_FLYING_POLLEN)
			{
				currentPollenCount = pollenForFlower2;
			}
			else
			{
				currentPollenCount += POLLEN_COUNT_PER_FLYING_POLLEN;
			}
			flowerIndex = 1;
		}
		else
		{
			if (pollenForFlower3 - currentPollenCount < POLLEN_COUNT_PER_FLYING_POLLEN)
			{
				currentPollenCount = pollenForFlower3;
			}
			else
			{
				currentPollenCount += POLLEN_COUNT_PER_FLYING_POLLEN;
			}
			flowerIndex = 2;
		}

		CCDelayTime *delayAction = [CCDelayTime actionWithDuration:(0.8f + i * 0.08f)];
		CCCallBlock *flyAction = [CCCallBlock actionWithBlock:^{

			CCSprite *flyingPollenSprite = [CCSprite spriteWithFile:@"Symbol-Pollen.png"];
			[flyingPollenSprite setPosition:[_pollenSprite position]];
			[self addChild:flyingPollenSprite];

			CGPoint targetPosition;
			if (flowerIndex == 0)
			{
				targetPosition = [_flowerSprite1Position position];
			}
			else if (flowerIndex == 1)
			{
				targetPosition = [_flowerSprite2Position position];
			}
			else
			{
				targetPosition = [_flowerSprite3Position position];
			}

			CCMoveTo *moveAction = [CCMoveTo actionWithDuration:0.15f position:targetPosition];
			CCCallBlock *removeAction = [CCCallBlock actionWithBlock:^{
				[self removeChild:flyingPollenSprite cleanup:TRUE];

				if (flowerIndex == 0)
				{
					float percentFlower1 = (float)(currentPollenCount) / pollenForFlower1;
					int numberOfPetalsFlower1 = (int)(percentFlower1 * 7);
					NSString *frameName;
					if (numberOfPetalsFlower1 == 0)
					{
						frameName = @"Flower/Flower-Screen-dim.png";
					}
					else if (numberOfPetalsFlower1 == 7)
					{
						frameName = @"Flower/Flower-Screen-full.png";

						CCScaleTo *scaleUpAction = [CCScaleTo actionWithDuration:0.1f scale:1.1f];
						CCScaleTo *scaleDownAction = [CCScaleTo actionWithDuration:0.1f scale:1.0f];
						[_flowerSprite1 runAction:[CCSequence actionOne:scaleUpAction two:scaleDownAction]];

						[[SoundManager sharedManager] playSound:@"FlowerCompleted"];
					}
					else
					{
						frameName = [NSString stringWithFormat:@"Flower/Flower-Screen-%d.png", numberOfPetalsFlower1];
					}
					CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
					[_flowerSprite1 setDisplayFrame:frame];
				}
				else if (flowerIndex == 1)
				{
					float percentFlower2 = (float)(currentPollenCount - pollenForFlower1) / (pollenForFlower2 - pollenForFlower1);
					int numberOfPetalsFlower2 = (int)(percentFlower2 * 7);
					NSString *frameName;
					if (numberOfPetalsFlower2 == 0)
					{
						frameName = @"Flower/Flower-Screen-dim.png";
					}
					else if (numberOfPetalsFlower2 == 7)
					{
						frameName = @"Flower/Flower-Screen-full.png";

						CCScaleTo *scaleUpAction = [CCScaleTo actionWithDuration:0.1f scale:1.1f];
						CCScaleTo *scaleDownAction = [CCScaleTo actionWithDuration:0.1f scale:1.0f];
						[_flowerSprite2 runAction:[CCSequence actionOne:scaleUpAction two:scaleDownAction]];

						[[SoundManager sharedManager] playSound:@"FlowerCompleted"];
					}
					else
					{
						frameName = [NSString stringWithFormat:@"Flower/Flower-Screen-%d.png", numberOfPetalsFlower2];
					}
					CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
					[_flowerSprite2 setDisplayFrame:frame];
				}
				else if (flowerIndex == 2)
				{
					float percentFlower3 = (float)(currentPollenCount - pollenForFlower2) / (pollenForFlower3 - pollenForFlower2);
					int numberOfPetalsFlower3 = (int)(percentFlower3 * 7);
					NSString *frameName = nil;
					if (numberOfPetalsFlower3 == 0)
					{
						frameName = @"Flower/Flower-Screen-dim.png";
					}
					else if (numberOfPetalsFlower3 == 7)
					{
						frameName = @"Flower/Flower-Screen-full.png";

						CCScaleTo *scaleUpAction = [CCScaleTo actionWithDuration:0.1f scale:1.1f];
						CCScaleTo *scaleDownAction = [CCScaleTo actionWithDuration:0.1f scale:1.0f];
						[_flowerSprite3 runAction:[CCSequence actionOne:scaleUpAction two:scaleDownAction]];

						[[SoundManager sharedManager] playSound:@"FlowerCompleted"];
					}
					else if (numberOfPetalsFlower3 < 7)
					{
						frameName = [NSString stringWithFormat:@"Flower/Flower-Screen-%d.png", numberOfPetalsFlower3];
					}
					if (frameName != nil)
					{
						CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
						[_flowerSprite3 setDisplayFrame:frame];
					}
				}
			}];
			[flyingPollenSprite runAction:[CCSequence actionOne:moveAction two:removeAction]];

			NSString *pollenString = [NSString stringWithFormat:@"%d", ([_levelSession totalNumberOfPollen] - currentPollenCount)];
			[_pollenLabel setString:pollenString];
		}];
		[[[CCDirector sharedDirector] actionManager] addAction:[CCSequence actionOne:delayAction two:flyAction] target:self paused:FALSE];

		i++;
	}
}

-(void) nextLevel
{
#ifdef LEVEL_RATINGS
	LevelLayout *levelLayout = [[LevelLayoutCache sharedLevelLayoutCache] levelLayoutByName:[_levelSession levelName]];
	if ([[LevelRatings sharedRatings] hasRatedLevel:[levelLayout levelName] withVersion:[levelLayout version]])
	{
		NSString *nextLevelName = [[LevelOrganizer sharedOrganizer] levelNameAfter:[_levelSession levelName]];
		if (nextLevelName != nil)
		{
			[GameStateUtils replaceWithGameplayState:nextLevelName game:_game];
		}
		else
		{
			[_game replaceState:[PlayState state]];
		}
	}
	else
	{
		[_game replaceState:[RateLevelState stateWithLevelName:[_levelSession levelName]]];
	}
#else
    NSString *nextLevelName = [[LevelOrganizer sharedOrganizer] levelNameAfter:[_levelSession levelName]];
    if (nextLevelName != nil)
    {
        [GameStateUtils replaceWithGameplayState:nextLevelName game:_game];
    }
    else
    {
		[_game replaceState:[PlayState state]];
    }
#endif
}

-(void) restartGame
{
	[_game replaceState:[GameplayState stateWithLevelName:[_levelSession levelName]]];
}

-(void) exitGame
{
	NSString *theme = [[LevelOrganizer sharedOrganizer] themeForLevel:[_levelSession levelName]];
	[_game clearAndReplaceState:[LevelSelectMenuState stateWithTheme:theme]];
}

@end
