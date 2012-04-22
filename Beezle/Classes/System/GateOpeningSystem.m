//
//  GateOpeningSystem.m
//  Beezle
//
//  Created by KM Lagerstrom on 23/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GateOpeningSystem.h"
#import "DisposableComponent.h"
#import "EntityUtil.h"
#import "GateComponent.h"
#import "LevelSession.h"
#import "PlayerInformation.h"
#import "RenderComponent.h"
#import "RenderSprite.h"
#import "SoundManager.h"

@implementation GateOpeningSystem

// Designated initialiser
-(id) initWithLevelSession:(LevelSession *)levelSession
{
	if (self = [super initWithUsedComponentClasses:[NSArray arrayWithObject:[GateComponent class]]])
	{
		_levelSession = levelSession;
	}
	return self;
}

-(id) init
{
	return [self initWithLevelSession:nil];
}

-(void) processEntity:(Entity *)entity
{
	GroupManager *groupManager = (GroupManager *)[_world getManager:[GroupManager class]];
	NSArray *beeaterEntities = [groupManager getEntitiesInGroup:@"BEEATERS"];
	BOOL undisposedBeeatersLeft = 0;
	for (Entity *beeaterEntity in beeaterEntities)
	{
		if (![EntityUtil isEntityDisposed:beeaterEntity])
		{
			undisposedBeeatersLeft = TRUE;
			break;
		}
	}
	if (!undisposedBeeatersLeft)
	{
		GateComponent *gateComponent = [GateComponent getFrom:entity];
		if ([[PlayerInformation sharedInformation] totalNumberOfKeys] > 0 &&
			![gateComponent isOpened])
		{
			[gateComponent setIsOpened:TRUE];
			
			RenderComponent *gateRenderComponent = [RenderComponent getFrom:entity];
			RenderSprite *gateDefaultRenderSprite = [gateRenderComponent defaultRenderSprite];
			[gateDefaultRenderSprite playAnimationsLoopLast:[NSArray arrayWithObjects:@"Cavegate-Opening", @"Cavegate-Open-Idle", nil]];
			
			[[SoundManager sharedManager] playSound:@"CaveDoorOpens"];
		}
	}
}

@end
