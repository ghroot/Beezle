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
	self = [super initWithUsedComponentClass:[SlingerComponent class]];
	return self;
}

-(void) entityAdded:(Entity *)entity
{
	SlingerComponent *slingerComponent = [SlingerComponent getFrom:entity];
	[slingerComponent resetAimPollenCountdown];
}

-(void) processEntity:(Entity *)entity
{
	SlingerComponent *slingerComponent = [SlingerComponent getFrom:entity];
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
	TrajectoryComponent *trajectoryComponent = [TrajectoryComponent getFrom:slingerEntity];
    if (![trajectoryComponent isZero])
    {
		SlingerComponent *slingerComponent = [SlingerComponent getFrom:slingerEntity];
		Entity *aimPollenEntity = [EntityFactory createAimPollen:_world withBeeType:[slingerComponent loadedBeeType] andVelocity:[trajectoryComponent startVelocity]];
		[EntityUtil setEntityPosition:aimPollenEntity position:[trajectoryComponent startPoint]];
    }
}

@end
