//
//  LevelFailedDialog.m
//  Beezle
//
//  Created by KM Lagerstrom on 08/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LevelFailedDialog.h"
#import "Game.h"
#import "GameplayState.h"
#import "LevelSession.h"
#import "LevelOrganizer.h"
#import "LevelSelectMenuState.h"

@implementation LevelFailedDialog

-(id) initWithGame:(Game *)game andLevelSession:(LevelSession *)levelSession
{
	if (self = [super initWithInterfaceFile:@"LevelFailedDialog.ccbi"])
	{
		_game = game;
        _levelSession = levelSession;
	}
	return self;
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
