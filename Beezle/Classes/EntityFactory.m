
//  EntityFactory.m
//  Beezle
//
//  Created by Me on 13/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EntityFactory.h"
#import "BoundryComponent.h"
#import "CircularBoundry.h"
#import "PhysicsComponent.h"
#import "RenderComponent.h"
#import "TransformComponent.h"

@implementation EntityFactory

+(Entity *) createSlinger:(World *)world withPosition:(CGPoint)position
{
    Entity *slingerEntity = [world createEntity];
    
    TransformComponent *transformComponent = [[TransformComponent alloc] initWithPosition:CGPointMake(position.x, position.y)];
    [slingerEntity addComponent:transformComponent];
    
    RenderComponent *renderComponent = [[RenderComponent alloc] initWithFile:@"BeeSlingerC-01.png"];
    [slingerEntity addComponent:renderComponent];
    
    [slingerEntity setTag:@"SLINGER"];
    
    [slingerEntity refresh];
    
    return slingerEntity;
}

+(Entity *) createBee:(World *)world withPosition:(CGPoint)position andVelocity:(CGPoint)velocity
{
    Entity *beeEntity = [world createEntity];
    
    TransformComponent *transformComponent = [[TransformComponent alloc] initWithPosition:CGPointMake(position.x, position.y)];
    [beeEntity addComponent:transformComponent];
    
    RenderComponent *renderComponent = [[RenderComponent alloc] initWithSpriteSheetName:@"Beeater" andFrameFormat:@"Beeater-0%i.png"];
    [renderComponent addAnimation:@"idle" withStartFrame:1 andEndFrame:9];
    [beeEntity addComponent:renderComponent];
    
    cpBody *body = cpBodyNew(1.0f, 1.0f);
    body->v = cpv(velocity.x, velocity.y);
    cpShape *shape = cpCircleShapeNew(body, 20, cpv(0, 0));
    shape->e = 0.8f;
    shape->u = 0.5f;
    shape->collision_type = COLLISION_TYPE_BEE;
//    cpShapeSetGroup(shape, 1);
    PhysicsComponent *physicsComponent = [[PhysicsComponent alloc] initWithBody:body andShape:shape];
    [beeEntity addComponent:physicsComponent];
    
    [beeEntity refresh];
    
    return beeEntity;
}

+(Entity *) createRamp:(World *)world withPosition:(CGPoint)position andRotation:(float)rotation
{
    Entity *rampEntity = [world createEntity];
    
    TransformComponent *transformComponent = [[TransformComponent alloc] initWithPosition:CGPointMake(position.x, position.y)];
    [rampEntity addComponent:transformComponent];
    
    RenderComponent *renderComponent = [[RenderComponent alloc] initWithSpriteSheetName:@"Ramp" andFrameFormat:@"RampCrach [ Sketch ]-0%i.png"];
    [renderComponent addAnimation:@"crash" withStartFrame:1 andEndFrame:8];
    [rampEntity addComponent:renderComponent];
    
    int num = 4;
    CGPoint verts[] = {
        CGPointMake(-90,-5),
        CGPointMake(-90, 5),
        CGPointMake( 90, 5),
        CGPointMake( 90,-5),
    };
    cpBody *body = cpBodyNew(1.0f, cpMomentForPoly(1.0f, num, verts, CGPointZero));
    cpBodyInitStatic(body);
    cpShape *shape = cpPolyShapeNew(body, num, verts, CGPointZero);
    shape->e = 0.8f;
    shape->u = 0.5f;
    shape->collision_type = COLLISION_TYPE_RAMP;
    cpBodySetAngle(body, rotation);
    PhysicsComponent *physicsComponent = [[PhysicsComponent alloc] initWithBody:body andShape:shape];
    [rampEntity addComponent:physicsComponent];
    
    [rampEntity refresh];
    
    return rampEntity;
}

@end
