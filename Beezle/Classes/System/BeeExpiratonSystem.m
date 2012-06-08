//
//  BeeSystem.m
//  Beezle
//
//  Created by Me on 02/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BeeExpiratonSystem.h"
#import "BeeComponent.h"
#import "EntityUtil.h"
#import "PhysicsComponent.h"

@interface BeeExpiratonSystem()

-(BOOL) shouldExpireDueToDestroyCountdown:(Entity *)entity;
-(BOOL) shouldExpireDueToSleepingBody:(Entity *)entity;
-(BOOL) shouldExpireDueToNoBeeatersLeft;

@end

@implementation BeeExpiratonSystem

-(id) init
{
    self = [super initWithUsedComponentClasses:[NSArray arrayWithObjects:[BeeComponent class], [PhysicsComponent class], nil]];
    return self;
}

-(void) dealloc
{
	[_beeComponentMapper release];
	[_physicsComponentMapper release];

	[super dealloc];
}

-(void) initialise
{
	_beeComponentMapper = [[ComponentMapper alloc] initWithEntityManager:[_world entityManager] componentClass:[BeeComponent class]];
	_physicsComponentMapper = [[ComponentMapper alloc] initWithEntityManager:[_world entityManager] componentClass:[PhysicsComponent class]];
}

-(void) entityAdded:(Entity *)entity
{
	BeeComponent *beeComponent = [_beeComponentMapper getComponentFor:entity];
	[beeComponent resetAutoDestroyCountdown];
}

-(void) processEntity:(Entity *)entity
{
    if (![EntityUtil isEntityDisposable:entity] ||
        ![EntityUtil isEntityDisposed:entity])
    {
        if ([self shouldExpireDueToDestroyCountdown:entity] ||
            [self shouldExpireDueToSleepingBody:entity] ||
				[self shouldExpireDueToNoBeeatersLeft])
        {
            [EntityUtil destroyEntity:entity];
        }
    }
}

-(BOOL) shouldExpireDueToDestroyCountdown:(Entity *)entity
{
	BeeComponent *beeComponent = [_beeComponentMapper getComponentFor:entity];
    [beeComponent decreaseAutoDestroyCountdown:[_world delta]];
    return [beeComponent didAutoDestroyCountdownReachZero];
}

-(BOOL) shouldExpireDueToSleepingBody:(Entity *)entity
{
	BeeComponent *beeComponent = [_beeComponentMapper getComponentFor:entity];
	if ([[beeComponent type] doesExpire])
	{
		PhysicsComponent *physicsComponent = [_physicsComponentMapper getComponentFor:entity];
		return [[physicsComponent body] isSleeping];
	}
	else
	{
		return FALSE;
	}
}

-(BOOL) shouldExpireDueToNoBeeatersLeft
{
    GroupManager *groupManager = (GroupManager *)[_world getManager:[GroupManager class]];
    NSArray *beeaterEntities = [groupManager getEntitiesInGroup:@"BEEATERS"];
    BOOL worldHasBeeatersLeft = FALSE;
    for (Entity *beeaterEntity in beeaterEntities)
    {
        if (![EntityUtil isEntityDisposed:beeaterEntity])
        {
            worldHasBeeatersLeft = TRUE;
            break;
        }
    }
    return !worldHasBeeatersLeft;
}

@end
