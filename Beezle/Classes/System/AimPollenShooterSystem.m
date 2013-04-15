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
	TrajectoryComponent *trajectoryComponent = [_trajectoryComponentMapper getComponentFor:entity];
	if (![trajectoryComponent isZero])
	{
		SlingerComponent *slingerComponent = [_slingerComponentMapper getComponentFor:entity];
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
		float duration = [slingerComponent isGogglesActive] ? 1.6f : 0.8f;
	    Entity *aimPollenEntity = [EntityFactory createAimPollen:_world withBeeType:[slingerComponent loadedBeeType] velocity:[trajectoryComponent startVelocity] duration:duration];
		[EntityUtil setEntityPosition:aimPollenEntity position:[trajectoryComponent startPoint]];
    }
}

@end
