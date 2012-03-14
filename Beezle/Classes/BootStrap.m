//
//  BootStrap.m
//  Beezle
//
//  Created by KM Lagerstrom on 04/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BootStrap.h"
#import "Game.h"
#import "LevelLayout.h"
#import "LevelLayoutCache.h"
#import "LevelLayoutEntry.h"
#import "LevelLoader.h"
#import "LevelOrganizer.h"
#import "MainMenuState.h"
#import "SoundManager.h"

@implementation BootStrap

-(id) initWithGame:(Game *)game
{
	if (self = [super init])
	{
		_game = game;
	}
	return self;
}

-(void) start
{
	[[SoundManager sharedManager] setup];
	[_game startWithState:[MainMenuState state]];
}

@end
