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
#import "LevelSession.h"

@interface LevelFailedMode()

-(void) showLevelFailedDialog;
-(void) restartLevel:(id)sender;

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
		[_systems addObject:[gameplayState renderSystem]];
		[_systems addObject:[gameplayState hudRenderingSystem]];
		[_systems addObject:[gameplayState beeQueueRenderingSystem]];
		[_systems addObject:[gameplayState spawnSystem]];
	}
	return self;
}

-(void) update
{
    [super update];
    
	if (_levelFailedMenu == nil)
	{
		[self showLevelFailedDialog];
	}
}

-(void) showLevelFailedDialog
{
	CCMenuItemImage *levelFailedMenuItem = [CCMenuItemImage itemWithNormalImage:@"Level Failed Bubble-01.png" selectedImage:@"Level Failed Bubble-01.png" target:self selector:@selector(restartLevel:)];
	_levelFailedMenu = [CCMenu menuWithItems:levelFailedMenuItem, nil];
	[levelFailedMenuItem setScale:0.25f];
	CCEaseElasticInOut *elasticScaleAction = [CCEaseBackOut actionWithAction:[CCScaleTo actionWithDuration:0.3f scale:1.0f]];
	[levelFailedMenuItem runAction:elasticScaleAction];
	[_uiLayer addChild:_levelFailedMenu];
}

-(void) restartLevel:(id)sender
{
	[_uiLayer removeChild:_levelFailedMenu cleanup:TRUE];
	
	[[_gameplayState game] replaceState:[GameplayState stateWithLevelName:[_levelSession levelName]]];
}

@end
