//
//  LevelFailedDialog.m
//  Beezle
//
//  Created by KM Lagerstrom on 08/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LevelFailedDialog.h"
#import "CCBReader.h"
#import "Game.h"
#import "GameplayState.h"

@interface LevelFailedDialog()

-(void) restartLevel;

@end

@implementation LevelFailedDialog

-(id) initWithGame:(Game *)game andLevelName:(NSString *)levelName
{
	if (self = [super init])
	{
		_game = game;
		_levelName = levelName;
		
		CCNode *interface = [CCBReader nodeGraphFromFile:@"LevelFailedDialog.ccbi" owner:self];
		[self addChild:interface];
		
		[interface setScale:0.2f];
		[interface runAction:[CCEaseBackOut actionWithAction:[CCScaleTo actionWithDuration:0.3f scale:1.0f]]];
	}
	return self;
}

-(void) restartLevel
{
	[_game replaceState:[GameplayState stateWithLevelName:_levelName]];
}

@end
