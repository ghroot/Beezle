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
#import "LevelSession.h"
#import "MainMenuState.h"
#import "PlayerInformation.h"

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

@end
