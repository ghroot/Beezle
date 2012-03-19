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

@interface LevelFailedDialog()

-(void) restartLevel;

@end

@implementation LevelFailedDialog

-(id) initWithGame:(Game *)game andLevelName:(NSString *)levelName
{
	if (self = [super initWithInterfaceFile:@"LevelFailedDialog.ccbi"])
	{
		_game = game;
		_levelName = levelName;
	}
	return self;
}

-(void) restartLevel
{
	[_game replaceState:[GameplayState stateWithLevelName:_levelName]];
}

@end
