
//  EntityFactory.m
//  Beezle
//
//  Created by Me on 13/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EntityFactory.h"
#import "BoundryComponent.h"
#import "CircularBoundry.h"
#import "CollisionTypes.h"
#import "PhysicsBody.h"
#import "PhysicsComponent.h"
#import "PhysicsShape.h"
#import "RenderComponent.h"
#import "RenderSprite.h"
#import "RenderSystem.h"
#import "TagManager.h"
#import "TransformComponent.h"

@implementation EntityFactory

+(Entity *) createBackground:(World *)world withFileName:(NSString *)fileName
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    Entity *backgroundEntity = [world createEntity];
    
    TransformComponent *transformComponent = [[[TransformComponent alloc] initWithPosition:CGPointMake(winSize.width / 2, winSize.height / 2)] autorelease];
    [backgroundEntity addComponent:transformComponent];
    
	RenderSystem *renderSystem = (RenderSystem *)[[world systemManager] getSystem:[RenderSystem class]];
	RenderSprite *renderSprite = [renderSystem createRenderSpriteWithFile:fileName z:-5];
	RenderComponent *renderComponent = [RenderComponent renderComponentWithRenderSprite:renderSprite];
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

+(Entity *) createEdge:(World *)world  withSize:(CGSize)size
{
    Entity *edgeEntity = [world createEntity];
    
    TransformComponent *transformComponent = [[[TransformComponent alloc] initWithPosition:CGPointMake(0.0f, 0.0f)] autorelease];
    [edgeEntity addComponent:transformComponent];
    
    int num = 4;
    CGPoint verts[] = {
        cpv(0.0f, 0.0f),
        cpv(size.width, 0.0f),
        cpv(size.width, size.height),
        cpv(0.0f, size.height)
    };
    cpBody *body = cpBodyNew(1.0f, cpMomentForPoly(1.0f, num, verts, CGPointZero));
    cpBodyInitStatic(body);
    NSMutableArray *physicsShapes = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < num; i++)
    {
        int nextI = i == num - 1 ? 0 : i + 1;
        cpShape *shape = cpSegmentShapeNew(body, verts[i], verts[nextI], 0);
        shape->e = 0.0f;
        shape->u = 0.5f;
        shape->collision_type = COLLISION_TYPE_EDGE;
        
        PhysicsShape *physicsShape = [[[PhysicsShape alloc] initWithShape:shape] autorelease];
        [physicsShapes addObject:physicsShape];
    }
    PhysicsBody *physicsBody = [[[PhysicsBody alloc] initWithBody:body] autorelease];
    PhysicsComponent *physicsComponent = [[[PhysicsComponent alloc] initWithBody:physicsBody andShapes:physicsShapes] autorelease];
    [edgeEntity addComponent:physicsComponent];
    
    [edgeEntity refresh];
    
    return edgeEntity;
}

+(Entity *) createSlinger:(World *)world withPosition:(CGPoint)position
{
    Entity *slingerEntity = [world createEntity];
    
    TransformComponent *transformComponent = [[[TransformComponent alloc] initWithPosition:CGPointMake(position.x, position.y)] autorelease];
    [slingerEntity addComponent:transformComponent];
	
	RenderSystem *renderSystem = (RenderSystem *)[[world systemManager] getSystem:[RenderSystem class]];
	RenderSprite *renderSprite = [renderSystem createRenderSpriteWithSpriteSheetName:@"Sling" z:-2];
    [[renderSprite sprite] setAnchorPoint:CGPointMake(0.5f, 1.0f)];
    RenderComponent *renderComponent = [RenderComponent renderComponentWithRenderSprite:renderSprite];
    [slingerEntity addComponent:renderComponent];
	
	TagManager *tagManager = (TagManager *)[world getManager:[TagManager class]];
	[tagManager registerEntity:slingerEntity withTag:@"SLINGER"];
    
    [slingerEntity refresh];
	
	[renderComponent playAnimation:@"Sling-Idle"];
    
    return slingerEntity;
}

+(Entity *) createBee:(World *)world withPosition:(CGPoint)position andVelocity:(CGPoint)velocity
{
    Entity *beeEntity = [world createEntity];
    
    TransformComponent *transformComponent = [[[TransformComponent alloc] initWithPosition:CGPointMake(position.x, position.y)] autorelease];
    [beeEntity addComponent:transformComponent];
    
	RenderSystem *renderSystem = (RenderSystem *)[[world systemManager] getSystem:[RenderSystem class]];
	RenderSprite *renderSprite = [renderSystem createRenderSpriteWithSpriteSheetName:@"Bee" z:-3];
    RenderComponent *renderComponent = [RenderComponent renderComponentWithRenderSprite:renderSprite];
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
	
	[renderComponent playAnimation:@"Bee-Idle"];
    
    return beeEntity;
}

+(Entity *) createBeeater:(World *)world withPosition:(CGPoint)position
{
	Entity *beeaterEntity = [world createEntity];
	
    TransformComponent *transformComponent = [[[TransformComponent alloc] initWithPosition:CGPointMake(position.x, position.y)] autorelease];
    [beeaterEntity addComponent:transformComponent];
	
	RenderSystem *renderSystem = (RenderSystem *)[[world systemManager] getSystem:[RenderSystem class]];
	RenderSprite *bodyRenderSprite = [renderSystem createRenderSpriteWithSpriteSheetName:@"Beeater-Body" z:-2];
	[[bodyRenderSprite sprite] setAnchorPoint:CGPointMake(0.6f, 0.0f)];
	RenderSprite *headRenderSprite = [renderSystem createRenderSpriteWithSpriteSheetName:@"Beeater-Head" z:-1];
	[[headRenderSprite sprite] setAnchorPoint:CGPointMake(0.8f, -0.3f)];
    RenderComponent *renderComponent = [RenderComponent renderComponentWithRenderSprites:[NSArray arrayWithObjects:bodyRenderSprite, headRenderSprite, nil]];
    [beeaterEntity addComponent:renderComponent];
	
    cpBody *body = cpBodyNew(1.0f, 1.0f);
    cpBodyInitStatic(body);
    cpShape *circleShape = cpCircleShapeNew(body, 25, cpv(-20, 60));
    circleShape->e = 0.8f;
    circleShape->u = 0.5f;
    circleShape->collision_type = COLLISION_TYPE_BEEATER;
    CGPoint verts[] = {
        cpv(-20.0f, 0.0f),
        cpv(-20.0f, 50.0f),
        cpv(20.0f, 50.0f),
        cpv(20.0f, 0.0f)
    };
    cpShape *polyShape = cpPolyShapeNew(body, 4, verts, cpv(0, 0));
    polyShape->e = 0.8f;
    polyShape->u = 0.5f;
    polyShape->collision_type = COLLISION_TYPE_BEEATER;
    PhysicsBody *physicsBody = [[[PhysicsBody alloc] initWithBody:body] autorelease];
    PhysicsShape *circlePhysicsShape = [[[PhysicsShape alloc] initWithShape:circleShape] autorelease];
    PhysicsShape *polyPhysicsShape = [[[PhysicsShape alloc] initWithShape:polyShape] autorelease];
    PhysicsComponent *physicsComponent = [[[PhysicsComponent alloc] initWithBody:physicsBody andShapes:[NSArray arrayWithObjects:circlePhysicsShape, polyPhysicsShape, nil]] autorelease];
    [beeaterEntity addComponent:physicsComponent];
	
    [beeaterEntity refresh];
	
	[bodyRenderSprite playAnimation:@"Beeater-Body-Idle"];
	[headRenderSprite playAnimation:@"Beeater-Head-Idle"];
    
    return beeaterEntity;
}

+(Entity *) createRamp:(World *)world withPosition:(CGPoint)position andRotation:(float)rotation
{
    Entity *rampEntity = [world createEntity];
    
    TransformComponent *transformComponent = [[[TransformComponent alloc] initWithPosition:CGPointMake(position.x, position.y)] autorelease];
    [rampEntity addComponent:transformComponent];
    
	RenderSystem *renderSystem = (RenderSystem *)[[world systemManager] getSystem:[RenderSystem class]];
	RenderSprite *renderSprite = [renderSystem createRenderSpriteWithSpriteSheetName:@"Ramp" z:-2];
    RenderComponent *renderComponent = [RenderComponent renderComponentWithRenderSprite:renderSprite];
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
	
	[renderComponent playAnimation:@"Ramp-Idle"];
    
    return rampEntity;
}

+(Entity *) createPollen:(World *)world withPosition:(CGPoint)position
{
    Entity *pollenEntity = [world createEntity];
    
    TransformComponent *transformComponent = [[[TransformComponent alloc] initWithPosition:CGPointMake(position.x, position.y)] autorelease];
    [pollenEntity addComponent:transformComponent];
    
    RenderSystem *renderSystem = (RenderSystem *)[[world systemManager] getSystem:[RenderSystem class]];
	RenderSprite *renderSprite = [renderSystem createRenderSpriteWithSpriteSheetName:@"Pollen" z:-1];
    RenderComponent *renderComponent = [RenderComponent renderComponentWithRenderSprite:renderSprite];
    [pollenEntity addComponent:renderComponent];
    
    cpBody *body = cpBodyNew(1.0f, 1.0f);
    cpBodyInitStatic(body);
    cpShape *shape = cpCircleShapeNew(body, 15, cpv(0, 0));
    cpShapeSetSensor(shape, TRUE);
    shape->e = 0.8f;
    shape->u = 0.5f;
    shape->collision_type = COLLISION_TYPE_POLLEN;
    PhysicsBody *physicsBody = [[[PhysicsBody alloc] initWithBody:body] autorelease];
    PhysicsShape *physicsShape = [[[PhysicsShape alloc] initWithShape:shape] autorelease];
    PhysicsComponent *physicsComponent = [[[PhysicsComponent alloc] initWithBody:physicsBody andShape:physicsShape] autorelease];
    [pollenEntity addComponent:physicsComponent];
    
    [pollenEntity refresh];
    
    [renderComponent playAnimation:@"Pollen-Idle"];
    
    return pollenEntity;
}

+(Entity *) createMushroom:(World *)world withPosition:(CGPoint)position
{
    Entity *mushroomEntity = [world createEntity];
    
    TransformComponent *transformComponent = [[[TransformComponent alloc] initWithPosition:CGPointMake(position.x, position.y)] autorelease];
    [mushroomEntity addComponent:transformComponent];
    
    RenderSystem *renderSystem = (RenderSystem *)[[world systemManager] getSystem:[RenderSystem class]];
	RenderSprite *renderSprite = [renderSystem createRenderSpriteWithSpriteSheetName:@"Mushroom" z:-1];
    RenderComponent *renderComponent = [RenderComponent renderComponentWithRenderSprite:renderSprite];
    [mushroomEntity addComponent:renderComponent];
    
    cpBody *body = cpBodyNew(1.0f, 1.0f);
    cpBodyInitStatic(body);
    cpShape *shape = cpCircleShapeNew(body, 25, cpv(0, -10));
    shape->e = 1.5f;
    shape->u = 0.5f;
    shape->collision_type = COLLISION_TYPE_MUSHROOM;
    PhysicsBody *physicsBody = [[[PhysicsBody alloc] initWithBody:body] autorelease];
    PhysicsShape *physicsShape = [[[PhysicsShape alloc] initWithShape:shape] autorelease];
    PhysicsComponent *physicsComponent = [[[PhysicsComponent alloc] initWithBody:physicsBody andShape:physicsShape] autorelease];
    [mushroomEntity addComponent:physicsComponent];
    
    [mushroomEntity refresh];
    
    [renderComponent playAnimation:@"Mushroom-Idle"];
    
    return mushroomEntity;
}

@end
