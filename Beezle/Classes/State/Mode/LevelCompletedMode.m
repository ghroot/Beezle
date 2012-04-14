//
//  LevelCompleteMode.m
//  Beezle
//
//  Created by Marcus on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LevelCompletedMode.h"
#import "BeeQueueRenderingSystem.h"
#import "Game.h"
#import "GameplayState.h"
#import "LevelCompletedDialog.h"
#import "LevelOrganizer.h"
#import "LevelSession.h"
#import "MainMenuState.h"
#import "PlayerInformation.h"
#import "SlingerComponent.h"

@interface LevelCompletedMode()

-(void) updateLevelSessionWithNumberOfUnusedBees;
-(void) showLevelCompleteDialog;

@end

@implementation LevelCompletedMode

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
		[_systems addObject:[gameplayState cullingSystem]];
	}
	return self;
}

-(void) dealloc
{
	[_levelCompletedDialog release];
	
	[super dealloc];
}

-(void) update
{
	[super update];
	
	if (_hasTurnedBeesIntoPollen)
	{
		if (_levelCompletedDialog == nil &&
			![[_gameplayState beeQueueRenderingSystem] isBusy])
		{
			[self updateLevelSessionWithNumberOfUnusedBees];
			[self showLevelCompleteDialog];
			[[PlayerInformation sharedInformation] storeAndSave:_levelSession];
		}
	}
	else
	{
		[[_gameplayState beeQueueRenderingSystem] turnRemainingBeesIntoPollen];
		_hasTurnedBeesIntoPollen = TRUE;
	}
}

-(void) updateLevelSessionWithNumberOfUnusedBees
{
	TagManager *tagManager = (TagManager *)[[_gameplayState world] getManager:[TagManager class]];
	Entity *slingerEntity = [tagManager getEntity:@"SLINGER"];
	SlingerComponent *slingerComponent = [SlingerComponent getFrom:slingerEntity];
	int numberOfUnusedBees = [slingerComponent numberOfBeesInQueue];
	[_levelSession setNumberOfUnusedBees:numberOfUnusedBees];
}

-(void) showLevelCompleteDialog
{
	_levelCompletedDialog = [[LevelCompletedDialog alloc] initWithGame:[_gameplayState game] andLevelSession:_levelSession];
	[_uiLayer addChild:_levelCompletedDialog];
}

@end
