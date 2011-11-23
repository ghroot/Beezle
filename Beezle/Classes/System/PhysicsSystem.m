//
//  PhysicsSystem.m
//  Beezle
//
//  Created by Me on 08/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PhysicsSystem.h"
#import "CollisionSystem.h"
#import "Collision.h"
#import "PhysicsBody.h"
#import "PhysicsComponent.h"
#import "PhysicsShape.h"
#import "TransformComponent.h"

@implementation PhysicsSystem

@synthesize space = _space;

-(id) init
{
    self = [super initWithUsedComponentClasses:[NSArray arrayWithObjects:[TransformComponent class], [PhysicsComponent class], nil]];
    return self;
}

-(void) dealloc
{
    for (int i = 0; i < 4; i++)
    {
		cpShapeFree(_walls[i]);
	}
    
    cpSpaceFree(_space);
    _space = NULL;
    
    [super dealloc];
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
    Collision *collision = [[[Collision alloc] initWithFirstEntity:firstEntity andSecondEntity:secondEntity] autorelease];
    [collisionSystem pushCollision:collision];
}

-(void) initialise
{
    cpInitChipmunk();
    
    _space = cpSpaceNew();
    cpSpaceSetUserData(_space, self);
    _space->gravity = CGPointMake(0, -100);
    
    CGSize size = [[CCDirector sharedDirector] winSize];
	_walls[0] = cpSegmentShapeNew(_space->staticBody, ccp(0,0), ccp(size.width,0), 0.0f);
	_walls[1] = cpSegmentShapeNew(_space->staticBody, ccp(0,size.height), ccp(size.width,size.height), 0.0f);
	_walls[2] = cpSegmentShapeNew(_space->staticBody, ccp(0,0), ccp(0,size.height), 0.0f);
	_walls[3] = cpSegmentShapeNew(_space->staticBody, ccp(size.width,0), ccp(size.width,size.height), 0.0f);
	for (int i = 0; i < 4; i++)
    {
		_walls[i]->e = 0.1f;
		_walls[i]->u = 1.0f;
		cpSpaceAddStaticShape(_space, _walls[i]);
	}
    
    cpSpaceAddCollisionHandler(_space, COLLISION_TYPE_BEE, COLLISION_TYPE_RAMP, NULL, NULL, &postSolveCollision, NULL, NULL);
}

-(void) entityAdded:(Entity *)entity
{
    TransformComponent *transformComponent = (TransformComponent *)[entity getComponent:[TransformComponent class]];
    PhysicsComponent *physicsComponent = (PhysicsComponent *)[entity getComponent:[PhysicsComponent class]];
    
    cpBody *body = [[physicsComponent physicsBody] body];
    body->p = [transformComponent position];
    if (!cpBodyIsStatic(body))
    {
        cpSpaceAddBody(_space, body);
    }
    
    for (PhysicsShape *physicsShape in [physicsComponent physicsShapes])
    {
        cpShape *shape = [physicsShape shape];
        
        shape->data = entity;
        
        if (cpBodyIsStatic(body))
        {
            cpSpaceAddStaticShape(_space, shape);
        }
        else
        {
            cpSpaceAddShape(_space, shape);
        }   
    }
    
    [super entityAdded:entity];
}

-(void) entityRemoved:(Entity *)entity
{
    PhysicsComponent *physicsComponent = (PhysicsComponent *)[entity getComponent:[PhysicsComponent class]];
    
    cpBody *body = [[physicsComponent physicsBody] body];
    if (!cpBodyIsStatic(body))
    {
        cpSpaceRemoveBody(_space, body);
    }
    
    for (PhysicsShape *physicsShape in [physicsComponent physicsShapes])
    {
        cpShape *shape = [physicsShape shape];
        
        if (cpBodyIsStatic(body))
        {
            cpSpaceRemoveStaticShape(_space, shape);
        }
        else
        {
            cpSpaceRemoveShape(_space, shape);
        }
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

    cpBody *body = [[physicsComponent physicsBody] body];

    [transformComponent setPosition:cpv(body->p.x, body->p.y)];
    [transformComponent setRotation:CC_RADIANS_TO_DEGREES(-body->a)];
}

@end
