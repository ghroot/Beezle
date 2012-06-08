//
//  SpawnSystem.m
//  Beezle
//
//  Created by KM Lagerstrom on 10/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SpawnSystem.h"
#import "EntityFactory.h"
#import "EntityUtil.h"
#import "SpawnComponent.h"
#import "TransformComponent.h"

@implementation SpawnSystem

-(id) init
{
	self = [super initWithUsedComponentClasses:[NSArray arrayWithObjects:[SpawnComponent class], [TransformComponent class], nil]];
	return self;
}

-(void) dealloc
{
	[_spawnComponentMapper release];
	[_transformComponentMapper release];

	[super dealloc];
}

-(void) initialise
{
	_spawnComponentMapper = [[ComponentMapper alloc] initWithEntityManager:[_world entityManager] componentClass:[SpawnComponent class]];
	_transformComponentMapper = [[ComponentMapper alloc] initWithEntityManager:[_world entityManager] componentClass:[TransformComponent class]];
}

-(void) entityAdded:(Entity *)entity
{
	SpawnComponent *spawnComponent = [_spawnComponentMapper getComponentFor:entity];
	[spawnComponent resetCountdown];
}

-(void) processEntity:(Entity *)entity
{
	SpawnComponent *spawnComponent = [_spawnComponentMapper getComponentFor:entity];
	[spawnComponent decreaseAutoDestroyCountdown:[_world delta] / 1000.0f];
	if ([spawnComponent didAutoDestroyCountdownReachZero])
	{
		Entity *spawnedEntity = [EntityFactory createEntity:[spawnComponent entityType] world:_world];
		
		TransformComponent *transformComponent = [_transformComponentMapper getComponentFor:entity];
		CGPoint spawnPosition = [transformComponent position];
		spawnPosition.x += [spawnComponent offset].x;
		spawnPosition.y += [spawnComponent offset].y;
		[EntityUtil setEntityPosition:spawnedEntity position:spawnPosition];
		
		if ([spawnComponent autoDestroy])
		{
			[EntityUtil animateAndDeleteEntity:spawnedEntity];
		}
		
		[spawnComponent resetCountdown];
	}
}

@end
