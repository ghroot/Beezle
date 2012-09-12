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

		[self createFlowerSprites];
	}
	return self;
}

-(void) dealloc
{
	[_flowerSprite1 release];
	[_flowerSprite2 release];
	[_flowerSprite3 release];

	[super dealloc];
}

-(void) createFlowerSprites
{
	LevelLayout *layout = [[LevelLayoutCache sharedLevelLayoutCache] levelLayoutByName:[_levelSession levelName]];

	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Interface.plist"];

	_flowerSprite1 = [[CCSprite alloc] initWithSpriteFrameName:@"Flower/Flower-Screen-full.png"];
	[_flowerSprite1 setPosition:[_flowerSprite1Position position]];
	[self addChild:_flowerSprite1];

	_flowerSprite2 = [[CCSprite alloc] initWithSpriteFrameName:@"Flower/Flower-Screen-full.png"];
	[_flowerSprite2 setPosition:[_flowerSprite2Position position]];
	[self addChild:_flowerSprite2];
	float percentFlower2 = (float)[_levelSession totalNumberOfPollen] / [layout pollenForTwoFlowers];
	if (percentFlower2 == 0.0f)
	{
		CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Flower/Flower-Screen-dim.png"];
		[_flowerSprite2 setDisplayFrame:frame];
	}
	else if (percentFlower2 < 1.0f)
	{
		int numberOfPetalsFlower2 = (int)(percentFlower2 * 7);
		if (numberOfPetalsFlower2 == 0)
		{
			numberOfPetalsFlower2 = 1;
		}
		CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"Flower/Flower-Screen-%d.png", numberOfPetalsFlower2]];
		[_flowerSprite2 setDisplayFrame:frame];
	}

	_flowerSprite3 = [[CCSprite alloc] initWithSpriteFrameName:@"Flower/Flower-Screen-full.png"];
	[_flowerSprite3 setPosition:[_flowerSprite3Position position]];
	[self addChild:_flowerSprite3];
	float percentFlower3 = (float)([_levelSession totalNumberOfPollen] - [layout pollenForTwoFlowers]) / ([layout pollenForThreeFlowers] - [layout pollenForTwoFlowers]);
	if (percentFlower3 == 0.0f)
	{
		CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Flower/Flower-Screen-dim.png"];
		[_flowerSprite3 setDisplayFrame:frame];
	}
	else if (percentFlower3 < 1.0f)
	{
		int numberOfPetalsFlower3 = (int)(percentFlower3 * 7);
		if (numberOfPetalsFlower3 == 0)
		{
			numberOfPetalsFlower3 = 1;
		}
		CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"Flower/Flower-Screen-%d.png", numberOfPetalsFlower3]];
		[_flowerSprite3 setDisplayFrame:frame];
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
    [_game clearAndReplaceState:[PlayState state]];
}

@end
