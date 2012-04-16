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
#import "CollisionType.h"
#import "GlassPieceHandler.h"
#import "PhysicsSystem.h"
#import "WaterDropHandler.h"

@interface CollisionSystem()

-(void) registerCollisionHandler:(CollisionHandler *)handler;

@end

@implementation CollisionSystem

-(id) initWithLevelSession:(LevelSession *)levelSession
{
	if (self = [super init])
	{
		_levelSession = levelSession;
        _collisionHandlers = [NSMutableArray new];
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
    [_collisionHandlers release];
    
    [super dealloc];
}

-(void) initialise
{
    [self registerCollisionHandler:[BeeHandler handlerWithWorld:_world andLevelSession:_levelSession]];
    [self registerCollisionHandler:[AimPollenHandler handlerWithWorld:_world andLevelSession:_levelSession]];
    [self registerCollisionHandler:[GlassPieceHandler handlerWithWorld:_world andLevelSession:_levelSession]];
    [self registerCollisionHandler:[WaterDropHandler handlerWithWorld:_world andLevelSession:_levelSession]];
}

-(void) registerCollisionHandler:(CollisionHandler *)handler
{
    [_collisionHandlers addObject:handler];
    
    PhysicsSystem *physicsSystem = (PhysicsSystem *)[[_world systemManager] getSystem:[PhysicsSystem class]];
    for (CollisionType *secondCollisionType in [handler secondCollisionTypes])
    {   
        [physicsSystem detectCollisionsBetween:[handler firstCollisionType] and:secondCollisionType];
    }
}

-(BOOL) handleCollision:(Collision *)collision
{
    BOOL atLeastOneCollisionHandlerReturnedFalse = FALSE;
    
    for (CollisionHandler *handler in _collisionHandlers)
    {
        if ([handler firstCollisionType] == [collision firstCollisionType])
        {
            for (CollisionType *secondCollisionType in [handler secondCollisionTypes])
            {
                if (secondCollisionType == [collision secondCollisionType])
                {
                    if (![handler handleCollision:collision])
                    {
                        atLeastOneCollisionHandlerReturnedFalse = TRUE;
                    }
                }
            }
        }
    }
    
    if (atLeastOneCollisionHandlerReturnedFalse)
    {
        return FALSE;
    }
    else
    {
        return TRUE;
    }
}

@end
