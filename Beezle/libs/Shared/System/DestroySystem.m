//
//  DestroySystem.m
//  Beezle
//
//  Created by Marcus Lagerstrom on 01/03/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "DestroySystem.h"
#import "DestroyComponent.h"
#import "PhysicsComponent.h"
#import "EntityUtil.h"

@implementation DestroySystem

-(id) init
{
	self = [super initWithUsedComponentClass:[DestroyComponent class]];
	return self;
}

-(void) initialise
{
	_destroyComponentMapper = [[ComponentMapper alloc] initWithEntityManager:[_world entityManager] componentClass:[DestroyComponent class]];
	_physicsComponentMapper = [[ComponentMapper alloc] initWithEntityManager:[_world entityManager] componentClass:[PhysicsComponent class]];
}

-(void) dealloc
{
	[_destroyComponentMapper release];
	[_physicsComponentMapper release];

	[super dealloc];
}

-(void) entityAdded:(Entity *)entity
{
	DestroyComponent *destroyComponent = [_destroyComponentMapper getComponentFor:entity];
	[destroyComponent resetCurrentDuration];
}

-(void) processEntity:(Entity *)entity
{
	DestroyComponent *destroyComponent = [_destroyComponentMapper getComponentFor:entity];
	PhysicsComponent *physicsComponent = [_physicsComponentMapper getComponentFor:entity];
	if (ccpLength([[physicsComponent body] vel]) <= [destroyComponent maxVelocity])
	{
		[destroyComponent increaseCurrentDuration:[_world delta] / 1000.0f];

		if ([destroyComponent currentDuration] >= [destroyComponent minDuration])
		{
			[EntityUtil destroyEntity:entity];
		}
	}
	else
	{
		[destroyComponent resetCurrentDuration];
	}
}


@end
