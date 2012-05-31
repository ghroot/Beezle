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
	self = [super initWithUsedComponentClasses:[NSArray arrayWithObject:[SpawnComponent class]]];
	return self;
}

-(void) entityAdded:(Entity *)entity
{
	SpawnComponent *spawnComponent = [SpawnComponent getFrom:entity];
	[spawnComponent resetCountdown];
}

-(void) processEntity:(Entity *)entity
{
	SpawnComponent *spawnComponent = [SpawnComponent getFrom:entity];
	[spawnComponent decreaseAutoDestroyCountdown:[_world delta] / 1000.0f];
	if ([spawnComponent didAutoDestroyCountdownReachZero])
	{
		Entity *spawnedEntity = [EntityFactory createEntity:[spawnComponent entityType] world:_world];
		
		TransformComponent *transformComponent = [TransformComponent getFrom:entity];
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
