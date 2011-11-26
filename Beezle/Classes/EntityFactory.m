
//  EntityFactory.m
//  Beezle
//
//  Created by Me on 13/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EntityFactory.h"
#import "BoundryComponent.h"
#import "CircularBoundry.h"
#import "PhysicsBody.h"
#import "PhysicsComponent.h"
#import "PhysicsShape.h"
#import "RenderComponent.h"
#import "TagManager.h"
#import "TransformComponent.h"

@implementation EntityFactory

+(Entity *) createBackground:(World *)world withFileName:(NSString *)fileName
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    Entity *backgroundEntity = [world createEntity];
    
    TransformComponent *transformComponent = [[[TransformComponent alloc] initWithPosition:CGPointMake(winSize.width / 2, winSize.height / 2)] autorelease];
    [backgroundEntity addComponent:transformComponent];
    
    RenderComponent *renderComponent = [[[RenderComponent alloc] initWithFile:fileName] autorelease];
    [backgroundEntity addComponent:renderComponent];
    
    int num = 16;
    CGPoint verts[] = {
        cpv(-239.0f, 67.0f),
        cpv(-144.0f, 52.0f),
        cpv(-172.0f, -40.0f),
        cpv(-162.0f, -109.0f),
        cpv(-114.0f, -129.0f),
        cpv(5.0f, -76.0f),
        cpv(22.0f, -128.0f),
        cpv(68.0f, -149.0f),
        cpv(124.0f, -120.0f),
        cpv(150.0f, -72.0f),
        cpv(150.0f, -44.0f),
        cpv(93.0f, -20.0f),
        cpv(93.0f, 13.0f),
        cpv(147.0f, 19.0f),
        cpv(191.0f, 10.0f),
        cpv(238.0f, -33.0f)
    };
    cpBody *body = cpBodyNew(1.0f, cpMomentForPoly(1.0f, num, verts, CGPointZero));
    cpBodyInitStatic(body);
    NSMutableArray *physicsShapes = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < num - 1; i++)
    {
        cpShape *shape = cpSegmentShapeNew(body, verts[i], verts[i + 1], 0);
        shape->e = 0.4f;
        shape->u = 0.5f;
        shape->collision_type = COLLISION_TYPE_BACKGROUND;
        
        PhysicsShape *physicsShape = [[[PhysicsShape alloc] initWithShape:shape] autorelease];
        [physicsShapes addObject:physicsShape];
    }
    PhysicsBody *physicsBody = [[[PhysicsBody alloc] initWithBody:body] autorelease];
    PhysicsComponent *physicsComponent = [[[PhysicsComponent alloc] initWithBody:physicsBody andShapes:physicsShapes] autorelease];
    [backgroundEntity addComponent:physicsComponent];
    
    [backgroundEntity refresh];
    
    return backgroundEntity;
}

+(Entity *) createSlinger:(World *)world withPosition:(CGPoint)position
{
    Entity *slingerEntity = [world createEntity];
    
    TransformComponent *transformComponent = [[[TransformComponent alloc] initWithPosition:CGPointMake(position.x, position.y)] autorelease];
    [slingerEntity addComponent:transformComponent];
    
    RenderComponent *renderComponent = [[[RenderComponent alloc] initWithSpriteSheetName:@"BeeSlingerC" andFrameFormat:@"BeeSlingerC-0%i.png"] autorelease];
    [renderComponent addAnimation:@"idle" withStartFrame:1 andEndFrame:1];
    NSMutableArray *strechFrames = [NSMutableArray arrayWithObjects:
                                   [NSNumber numberWithInt:2],
                                   [NSNumber numberWithInt:3],
                                   [NSNumber numberWithInt:4],
                                   [NSNumber numberWithInt:5],
                                   nil];
    [renderComponent addAnimation:@"strech" withFrames:strechFrames];
    NSMutableArray *shootFrames = [NSMutableArray arrayWithObjects:
                                   [NSNumber numberWithInt:6],
                                   [NSNumber numberWithInt:7],
                                   [NSNumber numberWithInt:8],
                                   [NSNumber numberWithInt:9],
                                   [NSNumber numberWithInt:1],
                                   nil];
    [renderComponent addAnimation:@"shoot" withFrames:shootFrames];
    [slingerEntity addComponent:renderComponent];
    
	TagManager *tagManager = (TagManager *)[world getManager:[TagManager class]];
	[tagManager registerEntity:slingerEntity withTag:@"SLINGER"];
    
    [slingerEntity refresh];
    
    return slingerEntity;
}

+(Entity *) createBee:(World *)world withPosition:(CGPoint)position andVelocity:(CGPoint)velocity
{
    Entity *beeEntity = [world createEntity];
    
    TransformComponent *transformComponent = [[[TransformComponent alloc] initWithPosition:CGPointMake(position.x, position.y)] autorelease];
    [beeEntity addComponent:transformComponent];
    
    RenderComponent *renderComponent = [[[RenderComponent alloc] initWithSpriteSheetName:@"Bee" andFrameFormat:@"Bee-0%i.png"] autorelease];
    [renderComponent addAnimation:@"idle" withStartFrame:1 andEndFrame:3];
    [renderComponent addAnimation:@"fly" withStartFrame:4 andEndFrame:4];
    [beeEntity addComponent:renderComponent];
    
    cpBody *body = cpBodyNew(1.0f, 1.0f);
    body->v = cpv(velocity.x, velocity.y);
    cpShape *shape = cpCircleShapeNew(body, 10, cpv(0, 0));
    shape->e = 0.8f;
    shape->u = 0.5f;
    shape->collision_type = COLLISION_TYPE_BEE;
//    cpShapeSetGroup(shape, 1);
    PhysicsBody *physicsBody = [[[PhysicsBody alloc] initWithBody:body] autorelease];
    PhysicsShape *physicsShape = [[[PhysicsShape alloc] initWithShape:shape] autorelease];
    PhysicsComponent *physicsComponent = [[[PhysicsComponent alloc] initWithBody:physicsBody andShape:physicsShape] autorelease];
    [beeEntity addComponent:physicsComponent];
    
    [beeEntity refresh];
    
    return beeEntity;
}

+(Entity *) createRamp:(World *)world withPosition:(CGPoint)position andRotation:(float)rotation
{
    Entity *rampEntity = [world createEntity];
    
    TransformComponent *transformComponent = [[[TransformComponent alloc] initWithPosition:CGPointMake(position.x, position.y)] autorelease];
    [rampEntity addComponent:transformComponent];
    
    RenderComponent *renderComponent = [[[RenderComponent alloc] initWithSpriteSheetName:@"Ramp" andFrameFormat:@"RampCrach [ Sketch ]-0%i.png"] autorelease];
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
    PhysicsBody *physicsBody = [[[PhysicsBody alloc] initWithBody:body] autorelease];
    PhysicsShape *physicsShape = [[[PhysicsShape alloc] initWithShape:shape] autorelease];
    PhysicsComponent *physicsComponent = [[[PhysicsComponent alloc] initWithBody:physicsBody andShape:physicsShape] autorelease];
    [rampEntity addComponent:physicsComponent];
    
    [rampEntity refresh];
    
    return rampEntity;
}

@end
