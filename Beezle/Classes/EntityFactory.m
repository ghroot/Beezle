
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
	RenderSprite *renderSprite = [renderSystem createRenderSpriteWithFile:fileName];
	RenderComponent *renderComponent = [RenderComponent renderComponentWithRenderSprite:renderSprite];
    [renderComponent setZ:-5];
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
	RenderSprite *renderSprite = [renderSystem createRenderSpriteWithSpriteSheetName:@"BeeSlingerC"];
	[renderSprite addAnimation:@"idle" withFrameName:@"BeeSlingerC-01.png"];
	[renderSprite addAnimation:@"stretch1" withFrameNames:[NSArray arrayWithObjects:@"BeeSlingerC-02.png", nil]];
	[renderSprite addAnimation:@"stretch2" withFrameNames:[NSArray arrayWithObjects:@"BeeSlingerC-03.png", nil]];
	[renderSprite addAnimation:@"stretch3" withFrameNames:[NSArray arrayWithObjects:@"BeeSlingerC-04.png", nil]];
	[renderSprite addAnimation:@"stretch4" withFrameNames:[NSArray arrayWithObjects:@"BeeSlingerC-05.png", nil]];
	[renderSprite addAnimation:@"shoot" withFrameNames:[NSArray arrayWithObjects:@"BeeSlingerC-06.png", @"BeeSlingerC-07.png", @"BeeSlingerC-08.png", @"BeeSlingerC-09.png", @"BeeSlingerC-01.png", nil]];
    RenderComponent *renderComponent = [RenderComponent renderComponentWithRenderSprite:renderSprite];
    [slingerEntity addComponent:renderComponent];
	
	TagManager *tagManager = (TagManager *)[world getManager:[TagManager class]];
	[tagManager registerEntity:slingerEntity withTag:@"SLINGER"];
    
    [slingerEntity refresh];
	
	[renderComponent playAnimation:@"idle" withLoops:-1];
    
    return slingerEntity;
}

+(Entity *) createBee:(World *)world withPosition:(CGPoint)position andVelocity:(CGPoint)velocity
{
    Entity *beeEntity = [world createEntity];
    
    TransformComponent *transformComponent = [[[TransformComponent alloc] initWithPosition:CGPointMake(position.x, position.y)] autorelease];
    [beeEntity addComponent:transformComponent];
    
	RenderSystem *renderSystem = (RenderSystem *)[[world systemManager] getSystem:[RenderSystem class]];
	RenderSprite *renderSprite = [renderSystem createRenderSpriteWithSpriteSheetName:@"Bee"];
	[renderSprite addAnimation:@"idle" withFrameNames:[NSArray arrayWithObjects:@"Bee-01.png", @"Bee-02.png", @"Bee-03.png", nil]];
	[renderSprite addAnimation:@"fly" withFrameName:@"Bee-04.png"];
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
	
	[renderComponent playAnimation:@"idle" withLoops:-1];
    
    return beeEntity;
}

+(Entity *) createBeeater:(World *)world withPosition:(CGPoint)position
{
	Entity *beeaterEntity = [world createEntity];
	
    TransformComponent *transformComponent = [[[TransformComponent alloc] initWithPosition:CGPointMake(position.x, position.y)] autorelease];
    [beeaterEntity addComponent:transformComponent];
	
	RenderSystem *renderSystem = (RenderSystem *)[[world systemManager] getSystem:[RenderSystem class]];
	RenderSprite *bodyRenderSprite = [renderSystem createRenderSpriteWithSpriteSheetName:@"Beeater-Body"];
	[[bodyRenderSprite sprite] setAnchorPoint:CGPointMake(0.5f, 0.0f)];
	[bodyRenderSprite addAnimation:@"bodyAnim1" withFrameName:@"Beeater-Body-01.png"];
	[bodyRenderSprite addAnimation:@"bodyAnim2" withFrameNames:[NSArray arrayWithObjects:@"Beeater-Body-02.png", @"Beeater-Body-03.png", @"Beeater-Body-04.png", @"Beeater-Body-03.png", @"Beeater-Body-02.png", nil]];
	RenderSprite *headRenderSprite = [renderSystem createRenderSpriteWithSpriteSheetName:@"Beeater-Head"];
	[[headRenderSprite sprite] setAnchorPoint:CGPointMake(0.4f, 2.0f)];
	[headRenderSprite addAnimation:@"headAnim1" withFrameName:@"Beeater-Head-01.png"];
	[headRenderSprite addAnimation:@"headAnim2" withFrameNames:[NSArray arrayWithObjects:@"Beeater-Head-02.png", @"Beeater-Head-03.png", nil]];
    RenderComponent *renderComponent = [RenderComponent renderComponentWithRenderSprites:[NSArray arrayWithObjects:bodyRenderSprite, headRenderSprite, nil]];
    [beeEntity addComponent:renderComponent];
	
    cpBody *body = cpBodyNew(1.0f, 1.0f);
    cpBodyInitStatic(body);
    cpShape *shape = cpCircleShapeNew(body, 25, cpv(0, 0));
    cpShapeSetSensor(shape, TRUE);
    shape->e = 0.8f;
    shape->u = 0.5f;
    shape->collision_type = COLLISION_TYPE_BEEATER;
    PhysicsBody *physicsBody = [[[PhysicsBody alloc] initWithBody:body] autorelease];
    PhysicsShape *physicsShape = [[[PhysicsShape alloc] initWithShape:shape] autorelease];
    PhysicsComponent *physicsComponent = [[[PhysicsComponent alloc] initWithBody:physicsBody andShape:physicsShape] autorelease];
    [pollenEntity addComponent:physicsComponent];
	
    [beeaterEntity refresh];
	
//	[renderComponent playAnimation:@"idle" withLoops:-1]; // TODO: This line should map to the two below somehow
	[bodyRenderSprite playAnimation:@"idle" withLoops:-1];
	[headRenderSprite playAnimation:@"lick" withLoops:-1];
    
    return beeaterEntity;
}

+(Entity *) createRamp:(World *)world withPosition:(CGPoint)position andRotation:(float)rotation
{
    Entity *rampEntity = [world createEntity];
    
    TransformComponent *transformComponent = [[[TransformComponent alloc] initWithPosition:CGPointMake(position.x, position.y)] autorelease];
    [rampEntity addComponent:transformComponent];
    
	RenderSystem *renderSystem = (RenderSystem *)[[world systemManager] getSystem:[RenderSystem class]];
	RenderSprite *renderSprite = [renderSystem createRenderSpriteWithSpriteSheetName:@"Ramp"];
	[renderSprite addAnimation:@"idle" withFrameName:@"RampCrach [ Sketch ]-01.png"];
	[renderSprite addAnimation:@"crash" withFrameNames:[NSArray arrayWithObjects:@"RampCrach [ Sketch ]-02.png", @"RampCrach [ Sketch ]-03.png", @"RampCrach [ Sketch ]-04.png", @"RampCrach [ Sketch ]-05.png", @"RampCrach [ Sketch ]-06.png", @"RampCrach [ Sketch ]-07.png", @"RampCrach [ Sketch ]-08.png", nil]];
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
	
	[renderComponent playAnimation:@"idle" withLoops:-1];
    
    return rampEntity;
}

+(Entity *) createPollen:(World *)world withPosition:(CGPoint)position
{
    Entity *pollenEntity = [world createEntity];
    
    TransformComponent *transformComponent = [[[TransformComponent alloc] initWithPosition:CGPointMake(position.x, position.y)] autorelease];
    [pollenEntity addComponent:transformComponent];
    
	RenderSystem *renderSystem = (RenderSystem *)[[world systemManager] getSystem:[RenderSystem class]];
	CCSpriteBatchNode *spriteSheet = [renderSystem getSpriteSheetWithName:@"Pollen"];
	RenderSprite *renderSprite = [RenderSprite renderSpriteWithSpriteSheet:spriteSheet andFrameFormat:@"Pollen-0%i.png"];
    NSMutableArray *spinFrames = [NSMutableArray arrayWithObjects:
                                   [NSNumber numberWithInt:1],
                                   [NSNumber numberWithInt:2],
                                   [NSNumber numberWithInt:3],
                                   [NSNumber numberWithInt:4],
                                   [NSNumber numberWithInt:3],
                                   [NSNumber numberWithInt:2],
                                   nil];
    [renderSprite addAnimation:@"spin" withFrames:spinFrames];
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
    
    [renderComponent playAnimation:@"spin" withLoops:-1];
    
    return pollenEntity;
}

@end
