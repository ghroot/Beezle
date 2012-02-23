//
//  GateOpeningSystem.m
//  Beezle
//
//  Created by KM Lagerstrom on 23/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GateOpeningSystem.h"
#import "DisposableComponent.h"
#import "GateComponent.h"
#import "LevelSession.h"
#import "RenderComponent.h"
#import "SoundManager.h"

@implementation GateOpeningSystem

// Designated initializer
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
		if (![[DisposableComponent getFrom:beeaterEntity] isDisposed])
		{
			undisposedBeeatersLeft = TRUE;
			break;
		}
	}
	if (!undisposedBeeatersLeft)
	{
		GateComponent *gateComponent = [GateComponent getFrom:entity];
		if (![gateComponent isOpened])
		{
			[gateComponent setIsOpened:TRUE];
			
			[_levelSession setDidUseKey:TRUE];
			
			RenderComponent *gateRenderComponent = [RenderComponent getFrom:entity];
			[gateRenderComponent playAnimationsLoopLast:[NSArray arrayWithObjects:@"Cavegate-Opening", @"Cavegate-Open-Idle", nil]];
			
			[[SoundManager sharedManager] playSound:@"CaveDoorOpens"];
		}
	}
}

@end
