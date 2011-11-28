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
#import "PhysicsBody.h"
#import "PhysicsComponent.h"
#import "PhysicsShape.h"
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
        
        if ([[firstPhysicsComponent firstPhysicsShape] shape]->collision_type == COLLISION_TYPE_BEE)
        {
            [self handleCollisionBee:[collision firstEntity]];
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
        }
    }
    [_collisions removeAllObjects];    
}

-(void) handleCollisionBee:(Entity *)beeEntity
{
    RenderComponent *beeRenderComponent = (RenderComponent *)[beeEntity getComponent:[RenderComponent class]];
    [beeRenderComponent playAnimation:@"idle" withLoops:3];
}

-(void) handleCollisionBee:(Entity *)beeEntity withRamp:(Entity *)rampEntity
{
    // Crash animation (and delete entity at end of animation)
    RenderComponent *rampRenderComponent = (RenderComponent *)[rampEntity getComponent:[RenderComponent class]];
    [rampRenderComponent playAnimation:@"crash" withCallbackTarget:rampEntity andCallbackSelector:@selector(deleteEntity)];
    
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

-(void) dealloc
{
    [_collisions release];
    
    [super dealloc];
}

@end
