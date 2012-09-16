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

@interface LevelCompletedDialog()

-(void) createFlowerSprites;
-(float) calculateNumberOfFlowers;

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
	[_flowerSprite1 setScale:0.8f];
	[self addChild:_flowerSprite1];

	_flowerSprite2 = [[CCSprite alloc] initWithSpriteFrameName:@"Flower/Flower-Screen-dim.png"];
	[_flowerSprite2 setPosition:[_flowerSprite2Position position]];
	[_flowerSprite2 setScale:0.8f];
	[self addChild:_flowerSprite2];

	_flowerSprite3 = [[CCSprite alloc] initWithSpriteFrameName:@"Flower/Flower-Screen-dim.png"];
	[_flowerSprite3 setPosition:[_flowerSprite3Position position]];
	[_flowerSprite3 setScale:0.8f];
	[self addChild:_flowerSprite3];

	if ([layout pollenForTwoFlowers] == 0 ||
		[layout pollenForThreeFlowers] == 0)
	{
		return;
	}

	float numberOfFlowers = [self calculateNumberOfFlowers];
	float totalPercentFlower1 = min(1.0f, numberOfFlowers);
	float totalPercentFlower2 = min(1.0f, max(0.0f, numberOfFlowers - 1.0f));
	float totalPercentFlower3 = min(1.0f, max(0.0f, numberOfFlowers - 2.0f));
	float pollenPerFlower = [_levelSession totalNumberOfPollen] / numberOfFlowers;
	int pollenForFlower1 = (int)pollenPerFlower;
	int pollenForFlower2;
	int pollenForFlower3 = 0;
	if (numberOfFlowers < 2.0f)
	{
		pollenForFlower2 = [_levelSession totalNumberOfPollen] - pollenForFlower1;
	}
	else
	{
		pollenForFlower2 = (int)pollenPerFlower;
		pollenForFlower3 = [_levelSession totalNumberOfPollen] - pollenForFlower2 - pollenForFlower1;
	}

	for (int i = 0; i < [_levelSession totalNumberOfPollen]; i++)
	{
		CCSprite *flyingPollenSprite = [CCSprite spriteWithFile:@"Symbol-Pollen.png"];
		[flyingPollenSprite setPosition:[_pollenSprite position]];
		[flyingPollenSprite setScale:0.8f];
		[flyingPollenSprite setVisible:FALSE];
		[self addChild:flyingPollenSprite];

		int flowerIndex;
		if (i < pollenForFlower1)
		{
			flowerIndex = 0;
		}
		else if (i - pollenForFlower1 < pollenForFlower2)
		{
			flowerIndex = 1;
		}
		else
		{
			flowerIndex = 2;
		}

		CCDelayTime *delayAction = [CCDelayTime actionWithDuration:(0.8f + i * 0.15f)];
		CCCallBlock *flyAction = [CCCallBlock actionWithBlock:^{

			[_pollenSprite runAction:[CCSequence actionOne:[CCScaleTo actionWithDuration:0.05f scale:1.2f] two:[CCScaleTo actionWithDuration:0.05f scale:1.0f]]];

			[flyingPollenSprite setVisible:TRUE];

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

			CCMoveTo *moveAction = [CCMoveTo actionWithDuration:0.3f position:targetPosition];
			CCCallBlock *removeAction = [CCCallBlock actionWithBlock:^{
				[self removeChild:flyingPollenSprite cleanup:TRUE];

				if (flowerIndex == 0)
				{
					float percentFlower1 = (float)(i + 1) / pollenForFlower1 * totalPercentFlower1;
					int numberOfPetalsFlower1 = (int)(percentFlower1 * 7);
					NSString *frameName;
					if (numberOfPetalsFlower1 == 0)
					{
						frameName = @"Flower/Flower-Screen-dim.png";
					}
					else if (numberOfPetalsFlower1 == 7)
					{
						frameName = @"Flower/Flower-Screen-full.png";

						[_flowerSprite1 runAction:[CCEaseBounceOut actionWithAction:[CCScaleTo actionWithDuration:0.5f scale:1.2f]]];

						[[SoundManager sharedManager] playSound:@"FlowerCompleted"];
					}
					else
					{
						frameName = [NSString stringWithFormat:@"Flower/Flower-Screen-%d.png", numberOfPetalsFlower1];

						CCScaleTo *scaleUpAction = [CCScaleTo actionWithDuration:0.05f scale:0.9f];
						CCScaleTo *scaleDownAction = [CCScaleTo actionWithDuration:0.05f scale:0.8f];
						[_flowerSprite1 runAction:[CCSequence actionOne:scaleUpAction two:scaleDownAction]];
					}
					CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
					[_flowerSprite1 setDisplayFrame:frame];
				}
				else if (flowerIndex == 1)
				{
					float percentFlower2 = (float)(i + 1 - pollenForFlower1) / pollenForFlower2 * totalPercentFlower2;
					int numberOfPetalsFlower2 = (int)(percentFlower2 * 7);
					NSString *frameName;
					if (numberOfPetalsFlower2 == 0)
					{
						frameName = @"Flower/Flower-Screen-dim.png";
					}
					else if (numberOfPetalsFlower2 == 7)
					{
						frameName = @"Flower/Flower-Screen-full.png";

						[_flowerSprite2 runAction:[CCEaseBounceOut actionWithAction:[CCScaleTo actionWithDuration:0.5f scale:1.2f]]];

						[[SoundManager sharedManager] playSound:@"FlowerCompleted"];
					}
					else
					{
						frameName = [NSString stringWithFormat:@"Flower/Flower-Screen-%d.png", numberOfPetalsFlower2];

						CCScaleTo *scaleUpAction = [CCScaleTo actionWithDuration:0.05f scale:0.9f];
						CCScaleTo *scaleDownAction = [CCScaleTo actionWithDuration:0.05f scale:0.8f];
						[_flowerSprite2 runAction:[CCSequence actionOne:scaleUpAction two:scaleDownAction]];
					}
					CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
					[_flowerSprite2 setDisplayFrame:frame];
				}
				else if (flowerIndex == 2)
				{
					float percentFlower3 = (float)(i + 1 - pollenForFlower2 - pollenForFlower1) / pollenForFlower3 * totalPercentFlower3;
					int numberOfPetalsFlower3 = (int)(percentFlower3 * 7);
					NSString *frameName = nil;
					if (numberOfPetalsFlower3 == 0)
					{
						frameName = @"Flower/Flower-Screen-dim.png";
					}
					else if (numberOfPetalsFlower3 == 7)
					{
						frameName = @"Flower/Flower-Screen-full.png";

						[_flowerSprite3 runAction:[CCEaseBounceOut actionWithAction:[CCScaleTo actionWithDuration:0.5f scale:1.2f]]];

						[[SoundManager sharedManager] playSound:@"FlowerCompleted"];
					}
					else if (numberOfPetalsFlower3 < 7)
					{
						frameName = [NSString stringWithFormat:@"Flower/Flower-Screen-%d.png", numberOfPetalsFlower3];

						CCScaleTo *scaleUpAction = [CCScaleTo actionWithDuration:0.05f scale:0.9f];
						CCScaleTo *scaleDownAction = [CCScaleTo actionWithDuration:0.05f scale:0.8f];
						[_flowerSprite3 runAction:[CCSequence actionOne:scaleUpAction two:scaleDownAction]];
					}
					if (frameName != nil)
					{
						CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
						[_flowerSprite3 setDisplayFrame:frame];
					}
				}
			}];
			[flyingPollenSprite runAction:[CCSequence actionOne:moveAction two:removeAction]];

			CCScaleTo *scaleUpAction = [CCEaseSineOut actionWithAction:[CCScaleTo actionWithDuration:0.2f scale:1.5f]];
			CCScaleTo *scaleDownAction = [CCEaseSineIn actionWithAction:[CCScaleTo actionWithDuration:0.2f scale:1.0f]];
			[flyingPollenSprite runAction:[CCSequence actionOne:scaleUpAction two:scaleDownAction]];

			NSString *pollenString = [NSString stringWithFormat:@"%d", ([_levelSession totalNumberOfPollen] - (i + 1))];
			[_pollenLabel setString:pollenString];
		}];
		[flyingPollenSprite runAction:[CCSequence actionOne:delayAction two:flyAction]];
	}
}

-(float) calculateNumberOfFlowers
{
	LevelLayout *layout = [[LevelLayoutCache sharedLevelLayoutCache] levelLayoutByName:[_levelSession levelName]];

	int totalNumberOfPollen = [_levelSession totalNumberOfPollen];
	int pollenForTwoFlowers = [layout pollenForTwoFlowers];
	int pollenForThreeFlowers = [layout pollenForThreeFlowers];

	float numberOfFlowers = 1.0f;

	if (totalNumberOfPollen >= pollenForTwoFlowers)
	{
		numberOfFlowers += 1.0f;

		if (totalNumberOfPollen >= pollenForThreeFlowers)
		{
			numberOfFlowers += 1.0f;
		}
		else
		{
			float percentOfThirdFlower = (float)(totalNumberOfPollen - pollenForTwoFlowers)/(pollenForThreeFlowers - pollenForTwoFlowers);
			if (percentOfThirdFlower > 1.0f)
			{
				percentOfThirdFlower = 1.0f;
			}
			numberOfFlowers += percentOfThirdFlower;
		}
	}
	else
	{
		float percentOfSecondFlower = (float)totalNumberOfPollen / pollenForTwoFlowers;
		numberOfFlowers += percentOfSecondFlower;
	}

	return numberOfFlowers;
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
    [_game clearAndReplaceState:[PlayState state]];
}

@end
