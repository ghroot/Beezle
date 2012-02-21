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
#import "LevelLoader.h"
#import "LevelOrganizer.h"
#import "MainMenuState.h"
#import "SoundManager.h"

@interface BootStrap()

-(void) preloadAllLevelLayouts;

@end

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
	// Preload resources
	[[SoundManager sharedManager] setup];
	if (CONFIG_CAN_EDIT_LEVELS)
	{
		[self preloadAllLevelLayouts];
	}
	
	[_game startWithState:[MainMenuState state]];
}

-(void) preloadAllLevelLayouts
{
	NSArray *levelNames = [[LevelOrganizer sharedOrganizer] allLevelNames];
	for (NSString *levelName in levelNames)
	{
		LevelLayout *levelLayoutWithHighestVersion = [[LevelLoader sharedLoader] loadLevelLayoutWithHighestVersion:levelName];
		if (levelLayoutWithHighestVersion != nil)
		{
			[[LevelLayoutCache sharedLevelLayoutCache] addLevelLayout:levelLayoutWithHighestVersion];
		}
	}
}

@end
