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
#import "LevelOrganizer.h"
#import "LevelSession.h"
#import "MainMenuState.h"
#import "PlayerInformation.h"
#import "SlingerComponent.h"

@interface LevelCompletedMode()

-(void) updateLevelSessionWithNumberOfUnusedBees;
-(void) showLevelCompleteDialog;
-(void) loadNextLevel:(id)sender;

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
	}
	return self;
}

-(void) update
{
	[super update];
	
	if (_hasTurnedBeesIntoPollen)
	{
		if (_levelCompletedMenu == nil &&
			![[_gameplayState beeQueueRenderingSystem] isBusy])
		{
			[self updateLevelSessionWithNumberOfUnusedBees];
			[[PlayerInformation sharedInformation] storeAndSave:_levelSession];
			[self showLevelCompleteDialog];
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
	CCMenuItemImage *levelCompleteMenuItem = [CCMenuItemImage itemWithNormalImage:@"Level Completed Bubble-01.png" selectedImage:@"Level Completed Bubble-01.png" target:self selector:@selector(loadNextLevel:)];
	_levelCompletedMenu = [CCMenu menuWithItems:levelCompleteMenuItem, nil];
	[levelCompleteMenuItem setScale:0.25f];
	CCEaseElasticInOut *elasticScaleAction = [CCEaseBackOut actionWithAction:[CCScaleTo actionWithDuration:0.3f scale:1.0f]];
	[levelCompleteMenuItem runAction:elasticScaleAction];
	[_uiLayer addChild:_levelCompletedMenu];
}

-(void) loadNextLevel:(id)sender
{
	[_uiLayer removeChild:_levelCompletedMenu cleanup:TRUE];
	
    NSString *nextLevelName = [[LevelOrganizer sharedOrganizer] levelNameAfter:[_levelSession levelName]];
    if (nextLevelName != nil)
    {
        [[_gameplayState game] replaceState:[GameplayState stateWithLevelName:nextLevelName]];
    }
    else
    {
		[[_gameplayState game] replaceState:[MainMenuState state]];
    }
}

@end
