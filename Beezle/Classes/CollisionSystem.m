//
//  CollisionSystem.m
//  Beezle
//
//  Created by Me on 15/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CollisionSystem.h"
#import "Collision.h"
#import "PhysicsComponent.h"
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
        
        if ([firstPhysicsComponent shape]->collision_type == COLLISION_TYPE_BEE &&
            [secondPhysicsComponent shape]->collision_type == COLLISION_TYPE_RAMP)
        {
            [self handleCollisionBee:[collision firstEntity] withRamp:[collision secondEntity]];
        }
    }
    [_collisions removeAllObjects];    
}

-(void) handleCollisionBee:(Entity *)beeEntity withRamp:(Entity *)rampEntity
{
    RenderComponent *beeRenderComponent = (RenderComponent *)[beeEntity getComponent:[RenderComponent class]];
    [beeRenderComponent playAnimation:@"idle" withLoops:1];
    
    // Crash animation
    RenderComponent *rampRenderComponent = (RenderComponent *)[rampEntity getComponent:[RenderComponent class]];
    [rampRenderComponent playAnimation:@"crash" withLoops:1];
    
    // Disable physics component
    PhysicsComponent *physicsComponent = (PhysicsComponent *)[rampEntity getComponent:[PhysicsComponent class]];
    [physicsComponent disable];
    [rampEntity refresh];
}

-(void) dealloc
{
    [_collisions release];
    
    [super dealloc];
}

@end
