//
//  HealthSystem.m
//  Beezle
//
//  Created by KM Lagerstrom on 21/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HealthSystem.h"
#import "HealthComponent.h"

@implementation HealthSystem

-(id) init
{
	self = [super initWithUsedComponentClasses:[NSArray arrayWithObject:[HealthComponent class]]];
	return self;
}

-(void) dealloc
{
	[_healthComponentMapper release];

	[super dealloc];
}

-(void) initialise
{
	_healthComponentMapper = [[ComponentMapper alloc] initWithEntityManager:[_world entityManager] componentClass:[HealthComponent class]];
}

-(void) entityAdded:(Entity *)entity
{
	HealthComponent *healthComponent = [_healthComponentMapper getComponentFor:entity];
	[healthComponent resetHealthPointsLeft];
}

@end
