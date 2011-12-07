//
//  PhysicsSystem.m
//  Beezle
//
//  Created by Me on 08/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PhysicsSystem.h"
#import "BodyInfo.h"
#import "CollisionSystem.h"
#import "Collision.h"
#import "GCpShapeCache.h"
#import "PhysicsBody.h"
#import "PhysicsComponent.h"
#import "PhysicsShape.h"
#import "TransformComponent.h"

@implementation PhysicsSystem

@synthesize space = _space;

-(id) init
{
    if (self = [super initWithUsedComponentClasses:[NSArray arrayWithObjects:[TransformComponent class], [PhysicsComponent class], nil]])
    {
        _loadedShapeFileNames = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void) dealloc
{
    cpSpaceFree(_space);
    _space = NULL;
    
    [_loadedShapeFileNames release];
    
    [super dealloc];
}

int beginCollision(cpArbiter *arbiter, cpSpace *space, void *data)
{
    cpShape *firstShape;
    cpShape *secondShape;
    cpArbiterGetShapes(arbiter, &firstShape, &secondShape);
    
    Entity *firstEntity = (Entity *)firstShape->data;
    Entity *secondEntity = (Entity *)secondShape->data;
    
    PhysicsSystem *physicsSystem = (PhysicsSystem *)cpSpaceGetUserData(space);
    CollisionSystem *collisionSystem = (CollisionSystem *)[[[physicsSystem world] systemManager] getSystem:[CollisionSystem class]];
    Collision *collision = [Collision collisionWithFirstEntity:firstEntity andSecondEntity:secondEntity];
    [collisionSystem pushCollision:collision];
    
    return 0;
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
    Collision *collision = [Collision collisionWithFirstEntity:firstEntity andSecondEntity:secondEntity];
    [collisionSystem pushCollision:collision];
}

-(void) initialise
{   
    cpInitChipmunk();
    
    _space = cpSpaceNew();
    cpSpaceSetSleepTimeThreshold(_space, 1.0f);
    cpSpaceSetUserData(_space, self);
    _space->gravity = CGPointMake(0, -100);
}

-(PhysicsComponent *) createPhysicsComponentWithFile:(NSString *)fileName bodyName:(NSString *)bodyName isStatic:(BOOL)isStatic collisionType:(int)collisionType
{
    if (![_loadedShapeFileNames containsObject:fileName])
    {
        [[GCpShapeCache sharedShapeCache] addShapesWithFile:fileName];
        [_loadedShapeFileNames addObject:fileName];
    }
    
    BodyInfo *bodyInfo = [[GCpShapeCache sharedShapeCache] createBodyWithName:bodyName];
    
    PhysicsComponent *physicsComponent = [PhysicsComponent physicsBodyWithBody:[bodyInfo physicsBody] andShapes:[bodyInfo physicsShapes]];
    
    if (isStatic)
    {
        cpBodyInitStatic([[physicsComponent physicsBody] body]);
    }
    
    for (PhysicsShape *physicsShape in [physicsComponent physicsShapes])
    {
        cpShapeSetCollisionType([physicsShape shape], collisionType);
    }
    
    return physicsComponent;
}

-(void) detectBeforeCollisionsBetween:(CollisionType)type1 and:(CollisionType)type2
{
	cpSpaceAddCollisionHandler(_space, type1, type2, &beginCollision, NULL, NULL, NULL, NULL);
}

-(void) detectAfterCollisionsBetween:(CollisionType)type1 and:(CollisionType)type2
{
    cpSpaceAddCollisionHandler(_space, type1, type2, NULL, NULL, &postSolveCollision, NULL, NULL);
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
        
        shape->data = NULL;
        
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
    CGFloat dt = [_world delta] == 0 ? 0.0f : ([_world delta] / 1000.0f) / (CGFloat)steps;
    
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
