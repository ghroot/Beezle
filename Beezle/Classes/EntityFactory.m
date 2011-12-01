
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

+(Entity *) createBackground:(World *)world withSpriteSheetName:(NSString *)spriteSheetName
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    Entity *backgroundEntity = [world createEntity];
    
    TransformComponent *transformComponent = [[[TransformComponent alloc] initWithPosition:CGPointMake(winSize.width / 2, winSize.height / 2)] autorelease];
    [backgroundEntity addComponent:transformComponent];
    
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGB565];
    
	RenderSystem *renderSystem = (RenderSystem *)[[world systemManager] getSystem:[RenderSystem class]];
    RenderSprite *renderSprite = [renderSystem createRenderSpriteWithSpriteSheetName:spriteSheetName z:-5];
	[renderSprite setFrame:@"Level-A5.png"];
	RenderComponent *renderComponent = [RenderComponent renderComponentWithRenderSprite:renderSprite];
    [backgroundEntity addComponent:renderComponent];
    
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
    
    int num = 42;
    CGPoint verts[] = {
        cpv(-238.6f, 81.0f),
        cpv(-130.5f, 76.7f),
        cpv(-130.5f, 64.7f),
        cpv(-196.2f, 53.4f),
        cpv(-213.2f, 32.9f),
        cpv(-211.8f, 10.3f),
        cpv(-197.6f, -8.1f),
        cpv(-163.0f, -11.7f),
        cpv(-119.9f, -5.3f),
        cpv(-87.3f, 10.3f),
        cpv(-51.3f, 13.1f),
        cpv(-51.3f, 7.4f),
        cpv(-105.0f, -11.0f),
        cpv(-130.5f, -25.8f),
        cpv(-146.7f, -50.6f),
        cpv(-122.7f, -88.0f),
        cpv(-98.6f, -108.5f),
        cpv(-72.5f, -117.0f),
        cpv(-34.3f, -111.4f),
        cpv(37.1f, -85.2f),
        cpv(47.0f, -85.2f),
        cpv(84.5f, -104.3f),
        cpv(110.0f, -112.1f),
        cpv(143.9f, -111.4f),
        cpv(182.8f, -100.1f),
        cpv(196.9f, -25.1f),
        cpv(174.3f, 8.1f),
        cpv(138.9f, 19.4f),
        cpv(105.7f, 25.1f),
        cpv(68.9f, 17.3f),
        cpv(25.8f, 5.3f),
        cpv(23.0f, 13.8f),
        cpv(100.1f, 37.8f),
        cpv(139.7f, 61.2f),
        cpv(155.2f, 88.0f),
        cpv(156.6f, 107.8f),
        cpv(149.6f, 124.8f),
        cpv(138.9f, 134.0f),
        cpv(119.1f, 143.2f),
        cpv(95.1f, 145.3f),
        cpv(12.4f, 146.0f),
        cpv(8.8f, 159.5f)
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
	RenderSprite *renderSprite = [renderSystem createRenderSpriteWithSpriteSheetName:@"Sprites" animationFile:@"Sling-Animations.plist" z:-2];
    [[renderSprite sprite] setAnchorPoint:CGPointMake(0.5f, 1.0f)];
    RenderComponent *renderComponent = [RenderComponent renderComponentWithRenderSprite:renderSprite];
    [slingerEntity addComponent:renderComponent];
	
	TagManager *tagManager = (TagManager *)[world getManager:[TagManager class]];
	[tagManager registerEntity:slingerEntity withTag:@"SLINGER"];
    
    [slingerEntity refresh];
	
	[renderComponent playAnimation:@"Sling-Idle"];
    
    return slingerEntity;
}

+(Entity *) createBee:(World *)world type:(NSString *)type withPosition:(CGPoint)position andVelocity:(CGPoint)velocity
{
    Entity *beeEntity = [world createEntity];
    
    TransformComponent *transformComponent = [[[TransformComponent alloc] initWithPosition:CGPointMake(position.x, position.y)] autorelease];
    [beeEntity addComponent:transformComponent];
    
	RenderSystem *renderSystem = (RenderSystem *)[[world systemManager] getSystem:[RenderSystem class]];
	RenderSprite *renderSprite = [renderSystem createRenderSpriteWithSpriteSheetName:@"Sprites" animationFile:[NSString stringWithFormat:@"%@-Animations.plist", type] z:-3];
    RenderComponent *renderComponent = [RenderComponent renderComponentWithRenderSprite:renderSprite];
    [beeEntity addComponent:renderComponent];
	
    cpBody *body = cpBodyNew(1.0f, 1.0f);
    body->v = cpv(velocity.x, velocity.y);
    cpShape *shape = cpCircleShapeNew(body, 6, cpv(0, 0));
    shape->e = 0.8f;
    shape->u = 0.5f;
    shape->collision_type = COLLISION_TYPE_BEE;
//    cpShapeSetGroup(shape, 1);
    PhysicsBody *physicsBody = [[[PhysicsBody alloc] initWithBody:body] autorelease];
    PhysicsShape *physicsShape = [[[PhysicsShape alloc] initWithShape:shape] autorelease];
    PhysicsComponent *physicsComponent = [[[PhysicsComponent alloc] initWithBody:physicsBody andShape:physicsShape] autorelease];
    [beeEntity addComponent:physicsComponent];
    
    [beeEntity refresh];
	
	[renderComponent playAnimation:[NSString stringWithFormat:@"%@-Idle", type]];
    
    return beeEntity;
}

+(Entity *) createBeeater:(World *)world withPosition:(CGPoint)position mirrored:(BOOL)mirrored
{
	Entity *beeaterEntity = [world createEntity];
	
    TransformComponent *transformComponent = [[[TransformComponent alloc] initWithPosition:CGPointMake(position.x, position.y)] autorelease];
    if (mirrored)
    {
        [transformComponent setScale:CGPointMake(-1.0f, 1.0f)];
    }
    [beeaterEntity addComponent:transformComponent];
	
	RenderSystem *renderSystem = (RenderSystem *)[[world systemManager] getSystem:[RenderSystem class]];
	RenderSprite *bodyRenderSprite = [renderSystem createRenderSpriteWithSpriteSheetName:@"Sprites" animationFile:@"Beeater-Body-Animations.plist" z:-2];
	[[bodyRenderSprite sprite] setAnchorPoint:CGPointMake(0.6f, 0.0f)];
	RenderSprite *headRenderSprite = [renderSystem createRenderSpriteWithSpriteSheetName:@"Sprites" animationFile:@"Beeater-Head-Animations.plist" z:-1];
	[[headRenderSprite sprite] setAnchorPoint:CGPointMake(0.8f, -0.3f)];
    RenderComponent *renderComponent = [RenderComponent renderComponentWithRenderSprites:[NSArray arrayWithObjects:bodyRenderSprite, headRenderSprite, nil]];
    [beeaterEntity addComponent:renderComponent];
	
    cpBody *body = cpBodyNew(1.0f, 1.0f);
    cpBodyInitStatic(body);
    CGPoint verts[] = {
        cpv(-15.0f, 0.0f),
        cpv(-15.0f, 40.0f),
        cpv(15.0f, 40.0f),
        cpv(15.0f, 0.0f)
    };
    cpShape *polyShape = cpPolyShapeNew(body, 4, verts, cpv(0, 0));
    polyShape->e = 0.8f;
    polyShape->u = 0.5f;
    polyShape->collision_type = COLLISION_TYPE_BEEATER;
    PhysicsBody *physicsBody = [[[PhysicsBody alloc] initWithBody:body] autorelease];
    PhysicsShape *polyPhysicsShape = [[[PhysicsShape alloc] initWithShape:polyShape] autorelease];
    PhysicsComponent *physicsComponent = [[[PhysicsComponent alloc] initWithBody:physicsBody andShape:polyPhysicsShape] autorelease];
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
	RenderSprite *renderSprite = [renderSystem createRenderSpriteWithSpriteSheetName:@"Sprites" animationFile:@"Ramp-Animations.plist" z:-2];
    RenderComponent *renderComponent = [RenderComponent renderComponentWithRenderSprite:renderSprite];
    [rampEntity addComponent:renderComponent];
	
    int num = 4;
    CGPoint verts[] = {
        CGPointMake(-50,-4),
        CGPointMake(-50, 4),
        CGPointMake( 50, 4),
        CGPointMake( 50,-4),
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
	RenderSprite *renderSprite = [renderSystem createRenderSpriteWithSpriteSheetName:@"Sprites" animationFile:@"Pollen-Animations.plist" z:-1];
    RenderComponent *renderComponent = [RenderComponent renderComponentWithRenderSprite:renderSprite];
    [pollenEntity addComponent:renderComponent];
    
    cpBody *body = cpBodyNew(1.0f, 1.0f);
    cpBodyInitStatic(body);
    cpShape *shape = cpCircleShapeNew(body, 8, cpv(0, 0));
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
	RenderSprite *renderSprite = [renderSystem createRenderSpriteWithSpriteSheetName:@"Sprites" animationFile:@"Mushroom-Animations.plist" z:-1];
    [[renderSprite sprite] setAnchorPoint:CGPointMake(0.5f, 0.0f)];
    RenderComponent *renderComponent = [RenderComponent renderComponentWithRenderSprite:renderSprite];
    [mushroomEntity addComponent:renderComponent];
    
    cpBody *body = cpBodyNew(1.0f, 1.0f);
    cpBodyInitStatic(body);
    cpShape *shape = cpCircleShapeNew(body, 25, cpv(0, 20));
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
