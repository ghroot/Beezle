//
//  BeeSystem.m
//  Beezle
//
//  Created by Me on 02/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BeeExpiratonSystem.h"
#import "BeeComponent.h"
#import "BeeType.h"
#import "EntityUtil.h"
#import "PhysicsComponent.h"

@interface BeeExpiratonSystem()

-(BOOL) shouldExpireDueToDestroyCountdown:(Entity *)entity;
-(BOOL) shouldExpireDueToSleepingBody:(Entity *)entity;
-(BOOL) shouldExpireDueToNoBeeatersLeft:(Entity *)entity;

@end

@implementation BeeExpiratonSystem

-(id) init
{
    self = [super initWithUsedComponentClasses:[NSArray arrayWithObject:[BeeComponent class]]];
    return self;
}

-(void) entityAdded:(Entity *)entity
{
	[[BeeComponent getFrom:entity] resetAutoDestroyCountdown];
}

-(void) processEntity:(Entity *)entity
{
    if (![EntityUtil isEntityDisposable:entity] ||
        ![EntityUtil isEntityDisposed:entity])
    {
        if ([self shouldExpireDueToDestroyCountdown:entity] ||
            [self shouldExpireDueToSleepingBody:entity] ||
            [self shouldExpireDueToNoBeeatersLeft:entity])
        {
            [EntityUtil destroyEntity:entity];
        }
    }
}

-(BOOL) shouldExpireDueToDestroyCountdown:(Entity *)entity
{
    BeeComponent *beeComponent = [BeeComponent getFrom:entity];
    [beeComponent decreaseAutoDestroyCountdown:[_world delta]];
    return [beeComponent didAutoDestroyCountdownReachZero];
}

-(BOOL) shouldExpireDueToSleepingBody:(Entity *)entity
{
    BeeComponent *beeComponent = [BeeComponent getFrom:entity];
    PhysicsComponent *physicsComponent = [PhysicsComponent getFrom:entity];
    return [[beeComponent type] doesExpire] &&
        [[physicsComponent body] isSleeping];
}

-(BOOL) shouldExpireDueToNoBeeatersLeft:(Entity *)entity
{
    GroupManager *groupManager = (GroupManager *)[_world getManager:[GroupManager class]];
	
    NSArray *beeaterEntities = [groupManager getEntitiesInGroup:@"BEEATERS"];
    BOOL worldHasBeeatersLeft = FALSE;
    for (Entity *beeaterEntity in beeaterEntities)
    {
        if (![EntityUtil isEntityDisposable:beeaterEntity] ||
            ![EntityUtil isEntityDisposed:beeaterEntity])
        {
            worldHasBeeatersLeft = TRUE;
            break;
        }
    }
	
    return !worldHasBeeatersLeft;
}

@end
