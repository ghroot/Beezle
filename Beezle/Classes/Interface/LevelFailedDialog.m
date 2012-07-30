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

@implementation LevelFailedDialog

-(id) initWithGame:(Game *)game andLevelSession:(LevelSession *)levelSession
{
	if (self = [super initWithInterfaceFile:@"LevelFailedDialog.ccbi" andLevelSession:levelSession])
	{
		_game = game;

		[self useNoResumeButton];
		[self useOrangeRestartButton];
		[self useNoNextLevelButton];
	}
	return self;
}

-(void) restartGame
{
	[_game replaceState:[GameplayState stateWithLevelName:[_levelSession levelName]]];
}

@end
