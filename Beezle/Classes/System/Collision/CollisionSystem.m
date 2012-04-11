//
//  CollisionSystem.m
//  Beezle
//
//  Created by Me on 15/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CollisionSystem.h"
#import "AimPollenEdgeHandler.h"
#import "BeeBackgroundHandler.h"
#import "BeeBeeaterHandler.h"
#import "BeeEdgeHandler.h"
#import "BeeEggHandler.h"
#import "BeeGateHandler.h"
#import "BeeGlassHandler.h"
#import "BeeMushroomHandler.h"
#import "BeeNutHandler.h"
#import "BeePollenHandler.h"
#import "BeeWaterHandler.h"
#import "BeeWoodHandler.h"
#import "Collision.h"
#import "CollisionHandler.h"
#import "CollisionMediator.h"
#import "CollisionType.h"
#import "GlassPieceHandler.h"
#import "PhysicsSystem.h"
#import "WaterDropBackgroundHandler.h"

@interface CollisionSystem()

-(void) registerCollisionBetween:(CollisionType *)type1 and:(CollisionType *)type2 handler:(CollisionHandler *)handler;
-(CollisionMediator *) findMediatorForCollision:(Collision *)collision;
-(void) handleCollisions;

@end

@implementation CollisionSystem

-(id) initWithLevelSession:(LevelSession *)levelSession
{
	if (self = [super init])
	{
		_collisionMediators = [[NSMutableArray alloc] init];
        _collisions = [[NSMutableArray alloc] init];
		_levelSession = levelSession;
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
    [_collisions release];
    
    [super dealloc];
}

-(void) pushCollision:(Collision *)collision
{
    [_collisions addObject:collision];
}

-(void) initialise
{
    [self registerCollisionBetween:[CollisionType BEE] and:[CollisionType EDGE] handler:[BeeEdgeHandler handler]];
    [self registerCollisionBetween:[CollisionType BEE] and:[CollisionType BACKGROUND] handler:[BeeBackgroundHandler handler]];
    [self registerCollisionBetween:[CollisionType BEE] and:[CollisionType BEEATER] handler:[BeeBeeaterHandler handler]];
    [self registerCollisionBetween:[CollisionType BEE] and:[CollisionType POLLEN] handler:[BeePollenHandler handlerWithLevelSession:_levelSession]];
    [self registerCollisionBetween:[CollisionType BEE] and:[CollisionType MUSHROOM] handler:[BeeMushroomHandler handler]];
    [self registerCollisionBetween:[CollisionType BEE] and:[CollisionType NUT] handler:[BeeNutHandler handlerWithLevelSession:_levelSession]];
    [self registerCollisionBetween:[CollisionType BEE] and:[CollisionType EGG] handler:[BeeEggHandler handlerWithLevelSession:_levelSession]];
    [self registerCollisionBetween:[CollisionType BEE] and:[CollisionType GLASS] handler:[BeeGlassHandler handler]];
    [self registerCollisionBetween:[CollisionType BEE] and:[CollisionType GATE] handler:[BeeGateHandler handlerWithLevelSession:_levelSession]];
    [self registerCollisionBetween:[CollisionType BEE] and:[CollisionType WATER] handler:[BeeWaterHandler handlerWithWorld:_world]];
    [self registerCollisionBetween:[CollisionType BEE] and:[CollisionType WOOD] handler:[BeeWoodHandler handler]];
    
    [self registerCollisionBetween:[CollisionType AIM_POLLEN] and:[CollisionType EDGE] handler:[AimPollenEdgeHandler handler]];
    
    GlassPieceHandler *glassPieceHandler = [GlassPieceHandler handlerWithWorld:_world];
    [self registerCollisionBetween:[CollisionType GLASS_PIECE] and:[CollisionType EDGE] handler:glassPieceHandler];
    [self registerCollisionBetween:[CollisionType GLASS_PIECE] and:[CollisionType EDGE] handler:glassPieceHandler];
    
    [self registerCollisionBetween:[CollisionType WATER_DROP] and:[CollisionType EDGE] handler:[WaterDropBackgroundHandler handlerWithWorld:_world]];
}

-(void) registerCollisionBetween:(CollisionType *)type1 and:(CollisionType *)type2 handler:(CollisionHandler *)handler
{
	PhysicsSystem *physicsSystem = (PhysicsSystem *)[[_world systemManager] getSystem:[PhysicsSystem class]];
	[physicsSystem detectCollisionsBetween:type1 and:type2];
	
	CollisionMediator *mediator = [CollisionMediator mediatorWithType1:type1 type2:type2 handler:handler];
	[_collisionMediators addObject:mediator];
}

-(CollisionMediator *) findMediatorForCollision:(Collision *)collision
{
	for (CollisionMediator *mediator in _collisionMediators)
	{
        if ([mediator appliesForCollision:collision])
        {
            return mediator;
        }
	}	
	return nil;
}

-(void) begin
{
    [self handleCollisions];
}

-(void) handleCollisions
{
    for (Collision *collision in _collisions)
    {
		CollisionMediator *mediator = [self findMediatorForCollision:collision];
        NSAssert(mediator != nil, @"Collision mediator should always exist.");
        [mediator mediateCollision:collision];
    }
    [_collisions removeAllObjects];    
}

@end
