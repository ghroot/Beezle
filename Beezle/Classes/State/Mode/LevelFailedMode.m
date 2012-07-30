//
//  LevelFailedMode.m
//  Beezle
//
//  Created by Marcus on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LevelFailedMode.h"
#import "Game.h"
#import "GameplayState.h"
#import "LevelFailedDialog.h"
#import "LevelSession.h"
#import "SessionTracker.h"

static const float DIALOG_DELAY_IN_SECONDS = 1.0f;

@interface LevelFailedMode()

-(void) showLevelFailedDialog;

@end

@implementation LevelFailedMode

-(id) initWithGameplayState:(GameplayState *)gameplayState andUiLayer:(CCLayer *)uiLayer levelSession:(LevelSession *)levelSession
{
	if (self = [super initWithGameplayState:gameplayState])
	{
		_uiLayer = uiLayer;
		_levelSession = levelSession;
		
		[_systems addObject:[gameplayState physicsSystem]];
		[_systems addObject:[gameplayState collisionSystem]];
		[_systems addObject:[gameplayState waterWaveSystem]];
		[_systems addObject:[gameplayState renderSystem]];
		[_systems addObject:[gameplayState hudRenderingSystem]];
		[_systems addObject:[gameplayState beeQueueRenderingSystem]];
		[_systems addObject:[gameplayState spawnSystem]];
	}
	return self;
}

-(void) dealloc
{
	[_levelFailedDialog release];
	
	[super dealloc];
}

-(void) enter
{
	[super enter];
	
	[[SessionTracker sharedTracker] trackFailedLevel:[_levelSession levelName]];

	_timeInSecondsUntilDialog = DIALOG_DELAY_IN_SECONDS;
}

-(void) update:(float)delta
{
    [super update:delta];
    
	if (_levelFailedDialog == nil &&
		_timeInSecondsUntilDialog > 0)
	{
		_timeInSecondsUntilDialog -= delta;
		if (_timeInSecondsUntilDialog <= 0)
		{
			[self showLevelFailedDialog];
		}
	}
}

-(void) showLevelFailedDialog
{	
	_levelFailedDialog = [[LevelFailedDialog alloc] initWithGame:[_gameplayState game] andLevelSession:_levelSession];
	[_uiLayer addChild:_levelFailedDialog];
}

@end
