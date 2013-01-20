//
//  LevelCompleteMode.m
//  Beezle
//
//  Created by Marcus on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LevelCompletedMode.h"
#import "BeeQueueRenderingSystem.h"
#import "GameplayState.h"
#import "LevelCompletedDialog.h"
#import "LevelSession.h"
#import "PlayerInformation.h"
#import "SessionTracker.h"
#import "SlingerComponent.h"
#import "FacebookManager.h"
#import "GameCenterManager.h"

static const float DIALOG_DELAY_IN_SECONDS = 0.2f;

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
	[_levelCompletedDialog release];
	
	[super dealloc];
}

-(void) enter
{
	[super enter];

	[_gameplayState hidePauseButton];
	
	[[SessionTracker sharedTracker] trackCompletedLevel:[_levelSession levelName]];

	_timeInSecondsUntilDialog = DIALOG_DELAY_IN_SECONDS;
}

-(void) update:(float)delta
{
	[super update:delta];
	
	if (_hasTurnedBeesIntoPollen)
	{
		if (_levelCompletedDialog == nil &&
			![[_gameplayState beeQueueRenderingSystem] isBusy] &&
			_timeInSecondsUntilDialog > 0)
		{
			_timeInSecondsUntilDialog -= delta;
			if (_timeInSecondsUntilDialog <= 0)
			{
				[self updateLevelSessionWithNumberOfUnusedBees];
				[self showLevelCompleteDialog];
				[[PlayerInformation sharedInformation] storeAndSave:_levelSession];

#ifndef LITE_VERSION
				[[GameCenterManager sharedManager] reportScore:[[PlayerInformation sharedInformation] totalNumberOfPollen]];
				[[FacebookManager sharedManager] tryPostScore:[[PlayerInformation sharedInformation] totalNumberOfPollen]];
#endif
			}
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
