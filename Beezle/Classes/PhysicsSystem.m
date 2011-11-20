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
#import "CollisionSystem.h"
#import "Collision.h"
#import "World.h"

@implementation PhysicsSystem

@synthesize space = _space;

-(id) init
{
    self = [super initWithUsedComponentClasses:[NSArray arrayWithObjects:[TransformComponent class], [PhysicsComponent class], nil]];
    return self;
}

void postSolveCollision(cpArbiter *arbiter, cpSpace *space, void *data)
{
    cpShape *firstShape;
    cpShape *secondShape;
    cpArbiterGetShapes(arbiter, &firstShape, &secondShape);
    
    Entity *firstEntity = (Entity *)firstShape->data;
    Entity *secondEntity = (Entity *)secondShape->data;
    
    PhysicsSystem *physicsSystem = (PhysicsSystem *)cpSpaceGetUserData(space);
    CollisionSystem *collisionSystem = (CollisionSystem *)[[[physicsSystem world] systemManager] getSystem:[CollisionSystem class]];
    Collision *collision = [[Collision alloc] initWithFirstEntity:firstEntity andSecondEntity:secondEntity];
    [collisionSystem pushCollision:collision];
}

-(void) initialise
{
    cpInitChipmunk();
    
    _space = cpSpaceNew();
    cpSpaceSetUserData(_space, self);
    _space->gravity = CGPointMake(0, -100);
    
    cpSpaceAddCollisionHandler(_space, 1, 2, NULL, NULL, &postSolveCollision, NULL, NULL);
}

-(void) entityAdded:(Entity *)entity
{
    TransformComponent *transformComponent = (TransformComponent *)[entity getComponent:[TransformComponent class]];
    PhysicsComponent *physicsComponent = (PhysicsComponent *)[entity getComponent:[PhysicsComponent class]];
    
    cpBody *body = [physicsComponent body];
    cpShape *shape = [physicsComponent shape];
    
    shape->data = entity;
    body->p = [transformComponent position];
    
    if (cpBodyIsStatic(body))
    {
        cpSpaceAddStaticShape(_space, shape);
    }
    else
    {
        cpSpaceAddBody(_space, body);
        cpSpaceAddShape(_space, shape);
    }
    
    [super entityAdded:entity];
}

-(void) entityRemoved:(Entity *)entity
{
    PhysicsComponent *physicsComponent = (PhysicsComponent *)[entity getComponent:[PhysicsComponent class]];
    
    cpBody *body = [physicsComponent body];
    cpShape *shape = [physicsComponent shape];
    
    if (cpBodyIsStatic(body))
    {
        cpSpaceRemoveStaticShape(_space, shape);
    }
    else
    {
        cpSpaceRemoveBody(_space, body);
        cpSpaceRemoveShape(_space, shape);
    }
    
    [super entityRemoved:entity];
}

-(void) begin
{
    int steps = 2;
    CGFloat dt = [[CCDirector sharedDirector] animationInterval] / (CGFloat)steps;

    for (int i = 0; i < steps; i++)
    {
        cpSpaceStep(_space, dt);
    }
}

-(void) processEntity:(Entity *)entity
{
    TransformComponent *transformComponent = (TransformComponent *)[entity getComponent:[TransformComponent class]];
    PhysicsComponent *physicsComponent = (PhysicsComponent *)[entity getComponent:[PhysicsComponent class]];

    cpBody *body = [physicsComponent body];

    [transformComponent setPosition:cpv(body->p.x, body->p.y)];
    [transformComponent setRotation:CC_RADIANS_TO_DEGREES(-body->a)];
}

-(void) dealloc
{
    cpSpaceFree(_space);
    _space = NULL;
    
    [super dealloc];
}

@end
