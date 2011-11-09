//
//  PhysicsSystem.m
//  Beezle
//
//  Created by Me on 08/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PhysicsSystem.h"

#import "cocos2d.h"

#import "PhysicsComponent.h"
#import "TransformComponent.h"

@implementation PhysicsSystem

-(id) init
{
    if (self = [super init])
    {   
        // Init chipmunk
        cpInitChipmunk();
        
        _space = cpSpaceNew();
        _space->gravity = CGPointMake(0, -100);
    }
    return self;
}

-(void) entityAdded:(Entity *)entity
{
    TransformComponent *transformComponent = (TransformComponent *)[entity getComponent:[TransformComponent class]];
    PhysicsComponent *physicsComponent = (PhysicsComponent *)[entity getComponent:[PhysicsComponent class]];
    
    cpBody *body = [physicsComponent body];
    cpShape *shape = [physicsComponent shape];
    
    body->p = [transformComponent position];
    
    cpSpaceAddBody(_space, body);
    cpSpaceAddShape(_space, shape);
    
    [super entityAdded:entity];
}

-(void) update
{
    // Should use a fixed size step based on the animation interval.
	int steps = 2;
	CGFloat dt = [[CCDirector sharedDirector] animationInterval] / (CGFloat)steps;
	
	for (int i = 0; i < steps; i++)
    {
		cpSpaceStep(_space, dt);
	}
    
    for (Entity *entity in _entities)
    {
        TransformComponent *transformComponent = (TransformComponent *)[entity getComponent:[TransformComponent class]];
        PhysicsComponent *physicsComponent = (PhysicsComponent *)[entity getComponent:[PhysicsComponent class]];
        
        cpBody *body = [physicsComponent body];
        
        [transformComponent setPosition:cpv(body->p.x, body->p.y)];
        [transformComponent setRotation:CC_RADIANS_TO_DEGREES(-body->a)];
    }
}

-(void) dealloc
{
    cpSpaceFree(_space);
    _space = NULL;
    
    [super dealloc];
}

@end
