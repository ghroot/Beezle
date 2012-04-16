//
//  CollisionSystem.m
//  Beezle
//
//  Created by Me on 15/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CollisionSystem.h"
#import "AimPollenHandler.h"
#import "BeeHandler.h"
#import "Collision.h"
#import "CollisionHandler.h"
#import "CollisionMediator.h"
#import "CollisionType.h"
#import "GlassPieceHandler.h"
#import "PhysicsSystem.h"
#import "WaterDropHandler.h"

@interface CollisionSystem()

-(void) registerCollisionBetween:(CollisionType *)type1 and:(CollisionType *)type2 handler:(CollisionHandler *)handler;
-(NSArray *) findMediatorsForCollision:(Collision *)collision;

@end

@implementation CollisionSystem

-(id) initWithLevelSession:(LevelSession *)levelSession
{
	if (self = [super init])
	{
		_levelSession = levelSession;
		_collisionMediators = [[NSMutableArray alloc] init];
	}
	return self;
}

-(id) init
{
    self = [self initWithLevelSession:nil];
    return self;
}

-(void) dealloc
{
	[_collisionMediators release];
    
    [super dealloc];
}

-(void) initialise
{
    BeeHandler *beeHandler = [BeeHandler handlerWithWorld:_world andLevelSession:_levelSession];
    [self registerCollisionBetween:[CollisionType BEE] and:[CollisionType BEEATER] handler:beeHandler];
	[self registerCollisionBetween:[CollisionType BEE] and:[CollisionType EDGE] handler:beeHandler];
	[self registerCollisionBetween:[CollisionType BEE] and:[CollisionType EGG] handler:beeHandler];
    [self registerCollisionBetween:[CollisionType BEE] and:[CollisionType GLASS] handler:beeHandler];
	[self registerCollisionBetween:[CollisionType BEE] and:[CollisionType MUSHROOM] handler:beeHandler];
	[self registerCollisionBetween:[CollisionType BEE] and:[CollisionType NUT] handler:beeHandler];
	[self registerCollisionBetween:[CollisionType BEE] and:[CollisionType POLLEN] handler:beeHandler];
    [self registerCollisionBetween:[CollisionType BEE] and:[CollisionType RAMP] handler:beeHandler];
	[self registerCollisionBetween:[CollisionType BEE] and:[CollisionType WOOD] handler:beeHandler];
	[self registerCollisionBetween:[CollisionType BEE] and:[CollisionType WATER] handler:beeHandler];
    
	AimPollenHandler *aimPollenHandler = [AimPollenHandler handler];
    [self registerCollisionBetween:[CollisionType AIM_POLLEN] and:[CollisionType EDGE] handler:aimPollenHandler];
    
    GlassPieceHandler *glassPieceHandler = [GlassPieceHandler handlerWithWorld:_world];
    [self registerCollisionBetween:[CollisionType GLASS_PIECE] and:[CollisionType BACKGROUND] handler:glassPieceHandler];
    [self registerCollisionBetween:[CollisionType GLASS_PIECE] and:[CollisionType EDGE] handler:glassPieceHandler];
    
    WaterDropHandler *waterDropHandler = [WaterDropHandler handlerWithWorld:_world];
    [self registerCollisionBetween:[CollisionType WATER_DROP] and:[CollisionType BACKGROUND] handler:waterDropHandler];
    [self registerCollisionBetween:[CollisionType WATER_DROP] and:[CollisionType WATER] handler:waterDropHandler];
}

-(void) registerCollisionBetween:(CollisionType *)type1 and:(CollisionType *)type2 handler:(CollisionHandler *)handler
{
	PhysicsSystem *physicsSystem = (PhysicsSystem *)[[_world systemManager] getSystem:[PhysicsSystem class]];
	[physicsSystem detectCollisionsBetween:type1 and:type2];
	
	CollisionMediator *mediator = [CollisionMediator mediatorWithType1:type1 type2:type2 handler:handler];
	[_collisionMediators addObject:mediator];
}

-(BOOL) handleCollision:(Collision *)collision
{
    BOOL atLeastOneMediatorReturnedFalse = FALSE;
    
    NSArray *mediators = [self findMediatorsForCollision:collision];
    NSAssert([mediators count] > 0, @"At least one collision mediator should always exist.");
    for (CollisionMediator *mediator in mediators)
    {
        if (![mediator mediateCollision:collision])
        {
            atLeastOneMediatorReturnedFalse = TRUE;
        }
    }
    
    if (atLeastOneMediatorReturnedFalse)
    {
        return FALSE;
    }
    else
    {
        return TRUE;
    }
}

-(NSArray *) findMediatorsForCollision:(Collision *)collision
{
    NSMutableArray *matchingMediators = [NSMutableArray array];
	for (CollisionMediator *mediator in _collisionMediators)
	{
        if ([mediator appliesForCollision:collision])
        {
            [matchingMediators addObject:mediator];
        }
	}	
	return matchingMediators;
}

@end
