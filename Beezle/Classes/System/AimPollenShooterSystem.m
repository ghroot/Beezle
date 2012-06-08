//
//  AimPollenShooterSystem.m
//  Beezle
//
//  Created by KM Lagerstrom on 26/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AimPollenShooterSystem.h"
#import "EntityFactory.h"
#import "EntityUtil.h"
#import "SlingerComponent.h"
#import "TrajectoryComponent.h"

@interface AimPollenShooterSystem()

-(void) shootAimPollens:(Entity *)slingerEntity;

@end

@implementation AimPollenShooterSystem

-(id) init
{
	self = [super initWithUsedComponentClasses:[NSArray arrayWithObjects:[SlingerComponent class], [TrajectoryComponent class], nil]];
	return self;
}

-(void) dealloc
{
	[_slingerComponentMapper release];
	[_trajectoryComponentMapper release];

	[super dealloc];
}

-(void) initialise
{
	_slingerComponentMapper = [[ComponentMapper alloc] initWithEntityManager:[_world entityManager] componentClass:[SlingerComponent class]];
	_trajectoryComponentMapper = [[ComponentMapper alloc] initWithEntityManager:[_world entityManager] componentClass:[TrajectoryComponent class]];
}

-(void) entityAdded:(Entity *)entity
{
	SlingerComponent *slingerComponent = [_slingerComponentMapper getComponentFor:entity];
	[slingerComponent resetAimPollenCountdown];
}

-(void) processEntity:(Entity *)entity
{
	SlingerComponent *slingerComponent = [_slingerComponentMapper getComponentFor:entity];
	if ([slingerComponent state] == SLINGER_STATE_AIMING)
	{
		[slingerComponent decreaseAimPollenCountdown];
		if ([slingerComponent hasAimPollenCountdownReachedZero])
		{
			[self shootAimPollens:entity];
			[slingerComponent resetAimPollenCountdown];
		}
	}
}

-(void) shootAimPollens:(Entity *)slingerEntity
{
	TrajectoryComponent *trajectoryComponent = [_trajectoryComponentMapper getComponentFor:slingerEntity];
	if (![trajectoryComponent isZero])
    {
		SlingerComponent *slingerComponent = [_slingerComponentMapper getComponentFor:slingerEntity];
	    Entity *aimPollenEntity = [EntityFactory createAimPollen:_world withBeeType:[slingerComponent loadedBeeType] andVelocity:[trajectoryComponent startVelocity]];
		[EntityUtil setEntityPosition:aimPollenEntity position:[trajectoryComponent startPoint]];
    }
}

@end
