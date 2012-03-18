//
//  LevelCompletedDialog.m
//  Beezle
//
//  Created by KM Lagerstrom on 09/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LevelCompletedDialog.h"
#import "CCBReader.h"
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
	if (self = [super init])
	{
		_game = game;
		_levelSession = levelSession;
		
		CCNode *interface = [CCBReader nodeGraphFromFile:@"LevelCompletedDialog.ccbi" owner:self];
		[self addChild:interface];
		
		[interface setScale:0.2f];
		[interface runAction:[CCEaseBackOut actionWithAction:[CCScaleTo actionWithDuration:0.3f scale:1.0f]]];
		
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
