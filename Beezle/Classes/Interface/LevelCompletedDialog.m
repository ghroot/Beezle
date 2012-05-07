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
#import "LevelOrganizer.h"
#import "LevelRatings.h"
#import "LevelSession.h"
#import "MainMenuState.h"
#import "PlayerInformation.h"
#import "RateLevelState.h"

@interface LevelCompletedDialog()

-(void) loadNextLevel;

@end

@implementation LevelCompletedDialog

-(id) initWithGame:(Game *)game andLevelSession:(LevelSession *)levelSession
{
	if (self = [super initWithInterfaceFile:@"LevelCompletedDialog.ccbi"])
	{
		_game = game;
		_levelSession = levelSession;
		
		[_pollenCountLabel setString:[NSString stringWithFormat:@"%d", [levelSession totalNumberOfPollen]]];
	}
	return self;
}

-(void) loadNextLevel
{
#ifdef DEBUG
	if ([[LevelRatings sharedRatings] hasRated:[_levelSession levelName]])
	{
		NSString *nextLevelName = [[LevelOrganizer sharedOrganizer] levelNameAfter:[_levelSession levelName]];
		if (nextLevelName != nil)
		{
			[_game replaceState:[GameplayState stateWithLevelName:nextLevelName]];
		}
		else
		{
			[_game replaceState:[MainMenuState state]];
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
		[_game replaceState:[MainMenuState state]];
    }
#endif
}

@end
