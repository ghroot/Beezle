//
//  CollisionSystem.m
//  Beezle
//
//  Created by Me on 15/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CollisionSystem.h"
#import "cocos2d.h"
#import "Collision.h"
#import "CollisionTypes.h"
#import "PhysicsBody.h"
#import "PhysicsComponent.h"
#import "PhysicsShape.h"
#import "PhysicsSystem.h"
#import "RenderComponent.h"

@implementation CollisionSystem

-(id) init
{
    if (self = [super init])
    {
        _collisions = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void) pushCollision:(Collision *)collision
{
    [_collisions addObject:collision];
}

-(void) initialise
{   
    PhysicsSystem *physicsSystem = (PhysicsSystem *)[[_world systemManager] getSystem:[PhysicsSystem class]];
	
	[physicsSystem detectAfterCollisionsBetween:COLLISION_TYPE_BEE and:COLLISION_TYPE_BACKGROUND];
	[physicsSystem detectAfterCollisionsBetween:COLLISION_TYPE_BEE and:COLLISION_TYPE_BEEATER];
	[physicsSystem detectAfterCollisionsBetween:COLLISION_TYPE_BEE and:COLLISION_TYPE_EDGE];
	[physicsSystem detectBeforeCollisionsBetween:COLLISION_TYPE_BEE and:COLLISION_TYPE_POLLEN];
	[physicsSystem detectAfterCollisionsBetween:COLLISION_TYPE_BEE and:COLLISION_TYPE_RAMP];
    [physicsSystem detectAfterCollisionsBetween:COLLISION_TYPE_BEE and:COLLISION_TYPE_MUSHROOM];
}

-(void) begin
{
    [self handleCollisions];
}

-(void) handleCollisions
{
    for (Collision *collision in _collisions)
    {
        PhysicsComponent *firstPhysicsComponent = (PhysicsComponent *)[[collision firstEntity] getComponent:[PhysicsComponent class]];
        PhysicsComponent *secondPhysicsComponent = (PhysicsComponent *)[[collision secondEntity] getComponent:[PhysicsComponent class]];
        
        if ([[firstPhysicsComponent firstPhysicsShape] shape]->collision_type == COLLISION_TYPE_BEE)
        {
            if ([[secondPhysicsComponent firstPhysicsShape] shape]->collision_type == COLLISION_TYPE_RAMP)
            {
                [self handleCollisionBee:[collision firstEntity] withRamp:[collision secondEntity]];
            }
            else if ([[secondPhysicsComponent firstPhysicsShape] shape]->collision_type == COLLISION_TYPE_BEEATER)
            {
                [self handleCollisionBee:[collision firstEntity] withBeeater:[collision secondEntity]];
            }
            else if ([[secondPhysicsComponent firstPhysicsShape] shape]->collision_type == COLLISION_TYPE_BACKGROUND)
            {
                [self handleCollisionBee:[collision firstEntity] withBackground:[collision secondEntity]];
            }
            else if ([[secondPhysicsComponent firstPhysicsShape] shape]->collision_type == COLLISION_TYPE_EDGE)
            {
                [self handleCollisionBee:[collision firstEntity] withEdge:[collision secondEntity]];
            }
            else if ([[secondPhysicsComponent firstPhysicsShape] shape]->collision_type == COLLISION_TYPE_POLLEN)
            {
                [self handleCollisionBee:[collision firstEntity] withPollen:[collision secondEntity]];
            }
            else if ([[secondPhysicsComponent firstPhysicsShape] shape]->collision_type == COLLISION_TYPE_MUSHROOM)
            {
                [self handleCollisionBee:[collision firstEntity] withMushroom:[collision secondEntity]];
            }
        }
    }
    [_collisions removeAllObjects];    
}

-(void) handleCollisionBee:(Entity *)beeEntity withRamp:(Entity *)rampEntity
{
    // Crash animation (and delete entity at end of animation)
    RenderComponent *rampRenderComponent = (RenderComponent *)[rampEntity getComponent:[RenderComponent class]];
    [rampRenderComponent playAnimation:@"Ramp-Crash" withCallbackTarget:rampEntity andCallbackSelector:@selector(deleteEntity)];
    
    // Disable physics component
    PhysicsComponent *physicsComponent = (PhysicsComponent *)[rampEntity getComponent:[PhysicsComponent class]];
    [physicsComponent disable];
    [rampEntity refresh];
}

-(void) handleCollisionBee:(Entity *)beeEntity withBeeater:(Entity *)beeaterEntity
{
	// Remove beeater
    [beeaterEntity deleteEntity];
	
	// Remove bee
	[beeEntity deleteEntity];
}

-(void) handleCollisionBee:(Entity *)beeEntity withBackground:(Entity *)backgroundEntity
{
}

-(void) handleCollisionBee:(Entity *)beeEntity withEdge:(Entity *)edgeEntity
{
	// Remove bee
	[beeEntity deleteEntity];
}

-(void) handleCollisionBee:(Entity *)beeEntity withPollen:(Entity *)pollenEntity
{
    [pollenEntity deleteEntity];
}

-(void)handleCollisionBee:(Entity *)beeEntity withMushroom:(Entity *)mushroomEntity
{
    RenderComponent *mushroomRenderComponent = (RenderComponent *)[mushroomEntity getComponent:[RenderComponent class]];
	[mushroomRenderComponent playAnimationsLoopLast:[NSArray arrayWithObjects:@"Mushroom-Bounce", @"Mushroom-Idle", nil]];
}

-(void) dealloc
{
    [_collisions release];
    
    [super dealloc];
}

@end
