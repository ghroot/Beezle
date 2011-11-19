//
//  CollisionSystem.m
//  Beezle
//
//  Created by Me on 15/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CollisionSystem.h"

#import "Entity.h"
#import "RenderComponent.h"
#import "PhysicsComponent.h"

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
    // TEMP
    for (Collision *collision in _collisions)
    {
//        [[collision secondEntity] deleteEntity];
        
        // Crash animation
        RenderComponent *renderComponent = (RenderComponent *)[[collision secondEntity] getComponent:[RenderComponent class]];
        [renderComponent playAnimation:@"crash" withLoops:1];
        
        // Disable physics component
        PhysicsComponent *physicsComponent = (PhysicsComponent *)[[collision secondEntity] getComponent:[PhysicsComponent class]];
        [physicsComponent disable];
        [[collision secondEntity] refresh];
    }
    [_collisions removeAllObjects];
}

-(void) dealloc
{
    [_collisions release];
    
    [super dealloc];
}

@end
