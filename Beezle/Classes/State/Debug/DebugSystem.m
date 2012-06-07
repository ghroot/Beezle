//
//  DebugSystem.m
//  Beezle
//
//  Created by KM Lagerstrom on 28/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DebugSystem.h"
#import "TransformComponent.h"

static const int LOOPS = 1000;

@implementation DebugSystem

@synthesize slow = _slow;

-(id) init
{
	if (self = [super initWithUsedComponentClass:[TransformComponent class]])
	{
		_slow = TRUE;
	}
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
	if (_slow)
	{
		for (int i = 0; i < LOOPS; i++)
		{
			[TransformComponent getFrom:entity];
		}
	}
	else
	{
		for (int i = 0; i < LOOPS; i++)
		{
			[_transformComponentMapper getComponentFor:entity];
		}
	}
}

@end

