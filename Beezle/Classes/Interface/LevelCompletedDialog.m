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

@implementation LevelCompletedDialog

-(id) initWithGame:(Game *)game andLevelSession:(LevelSession *)levelSession
{
	if (self = [super initWithInterfaceFile:@"LevelCompletedDialog.ccbi" andLevelSession:levelSession])
	{
		_game = game;

		[self useNoResumeButton];
		[self useWhiteRestartButton];
		[self useOrangeNextLevelButton];
	}
	return self;
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
			[_game replaceState:[GameplayState stateWithLevelName:nextLevelName]];
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
        [_game replaceState:[GameplayState stateWithLevelName:nextLevelName]];
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

@end
