//
//  DebugSystem.m
//  Beezle
//
//  Created by KM Lagerstrom on 28/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DebugSystem.h"
#import "TransformComponent.h"

@implementation DebugSystem

-(id) init
{
	self = [super initWithUsedComponentClass:[TransformComponent class]];
	return self;
}

-(void) dealloc
{
	[_transformComponentMapper release];

	[super dealloc];
}

-(void) initialise
{
	_transformComponentMapper = [[ComponentMapper alloc] initWithEntityManager:[_world entityManager] componentClass:[TransformComponent class]];
}

-(void) processEntity:(Entity *)entity
{
	// Slow
	[TransformComponent getFrom:entity];

	// Fast
	[_transformComponentMapper getComponentFor:entity];
}

@end
