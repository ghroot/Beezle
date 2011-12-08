
//  EntityFactory.m
//  Beezle
//
//  Created by Me on 13/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EntityFactory.h"
#import "BeeaterComponent.h"
#import "BeeComponent.h"
#import "BoundryComponent.h"
#import "CircularBoundry.h"
#import "CollisionTypes.h"
#import "GCpShapeCache.h"
#import "PhysicsBody.h"
#import "PhysicsComponent.h"
#import "PhysicsShape.h"
#import "PhysicsSystem.h"
#import "RenderComponent.h"
#import "RenderSprite.h"
#import "RenderSystem.h"
#import "SlingerComponent.h"
#import "TagManager.h"
#import "TrajectoryComponent.h"
#import "TransformComponent.h"

@implementation EntityFactory

+(Entity *) createBackground:(World *)world withLevelName:(NSString *)name
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    Entity *backgroundEntity = [world createEntity];
    
    // Transform
    TransformComponent *transformComponent = [TransformComponent componentWithPosition:CGPointMake(winSize.width / 2, winSize.height / 2)];
    [backgroundEntity addComponent:transformComponent];
    
    // Render
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGB565];
	RenderSystem *renderSystem = (RenderSystem *)[[world systemManager] getSystem:[RenderSystem class]];
    NSString *imageFileName = [NSString stringWithFormat:@"%@.jpg", name];
    RenderSprite *renderSprite = [renderSystem createRenderSpriteWithFile:imageFileName z:-5];
    [renderSprite markAsBackground];
	RenderComponent *renderComponent = [RenderComponent componentWithRenderSprite:renderSprite];
    [backgroundEntity addComponent:renderComponent];
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
    
    // Physics
    PhysicsSystem *physicsSystem = (PhysicsSystem *)[[world systemManager] getSystem:[PhysicsSystem class]];
    NSString *shapesFileName = [NSString stringWithFormat:@"%@-Shapes.plist", name];
    PhysicsComponent *physicsComponent = [physicsSystem createPhysicsComponentWithFile:shapesFileName bodyName:name isStatic:TRUE collisionType:COLLISION_TYPE_BACKGROUND];
    [backgroundEntity addComponent:physicsComponent];
    
    [backgroundEntity refresh];
    
    return backgroundEntity;    
}

+(Entity *) createEdge:(World *)world
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    Entity *edgeEntity = [world createEntity];
    
    // Transform
    TransformComponent *transformComponent = [TransformComponent componentWithPosition:CGPointMake(0.0f, 0.0f)];
    [edgeEntity addComponent:transformComponent];
    
    // Physics
    int num = 4;
    CGPoint verts[] = {
        cpv(0.0f, 0.0f),
        cpv(winSize.width, 0.0f),
        cpv(winSize.width, winSize.height),
        cpv(0.0f, winSize.height)
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
        
        PhysicsShape *physicsShape = [PhysicsShape physicsShapeWithShape:shape];
        [physicsShapes addObject:physicsShape];
    }
    PhysicsBody *physicsBody = [PhysicsBody physicsBodyWithBody:body];
    PhysicsComponent *physicsComponent = [PhysicsComponent componentWithBody:physicsBody andShapes:physicsShapes];
    [edgeEntity addComponent:physicsComponent];
    
    [edgeEntity refresh];
    
    return edgeEntity;
}

+(Entity *) createSlinger:(World *)world withPosition:(CGPoint)position
{
    Entity *slingerEntity = [world createEntity];
	
	// Slinger
	SlingerComponent *slingerComponent = [SlingerComponent component];
	[slingerComponent pushBeeType:BEE_TYPE_BEE];		// -
	[slingerComponent pushBeeType:BEE_TYPE_BEE];		//  |- TODO: Read from level description
	[slingerComponent pushBeeType:BEE_TYPE_BOMBEE];		// -
    for (int i = 0; i < 500; i++)
    {
        [slingerComponent pushBeeType:BEE_TYPE_BEE];
    }
	[slingerEntity addComponent:slingerComponent];
    
    // Transform
    TransformComponent *transformComponent = [TransformComponent componentWithPosition:CGPointMake(position.x, position.y)];
    [slingerEntity addComponent:transformComponent];
	
	// Trajectory
	TrajectoryComponent *trajectoryComponent = [TrajectoryComponent component];
	[slingerEntity addComponent:trajectoryComponent];
	
    // Render
	RenderSystem *renderSystem = (RenderSystem *)[[world systemManager] getSystem:[RenderSystem class]];
	RenderSprite *renderSprite = [renderSystem createRenderSpriteWithSpriteSheetName:@"Sprites" animationFile:@"Sling-Animations.plist" z:-2];
    [[renderSprite sprite] setAnchorPoint:CGPointMake(0.5f, 1.0f)];
    RenderComponent *renderComponent = [RenderComponent componentWithRenderSprite:renderSprite];
    [slingerEntity addComponent:renderComponent];
	
	TagManager *tagManager = (TagManager *)[world getManager:[TagManager class]];
	[tagManager registerEntity:slingerEntity withTag:@"SLINGER"];
    
    [slingerEntity refresh];
	
	[renderComponent playAnimation:@"Sling-Idle"];
    
    return slingerEntity;
}

+(Entity *) createBee:(World *)world type:(BeeType)type withPosition:(CGPoint)position andVelocity:(CGPoint)velocity
{
    Entity *beeEntity = [world createEntity];
	
    // Bee
	BeeComponent *beeComponent = [BeeComponent componentWithType:type];
	[beeEntity addComponent:beeComponent];
	
	// TEMP
	NSString *typeAsString = nil;
	if (type == BEE_TYPE_BEE)
	{
		typeAsString = @"Bee";
	}
	else if (type == BEE_TYPE_SAWEE)
	{
		typeAsString = @"Sawee";
	}
	else if (type == BEE_TYPE_SPEEDEE)
	{
		typeAsString = @"Speedee";
	}
	else if (type == BEE_TYPE_BOMBEE)
	{
		typeAsString = @"Bombee";
	}
	NSString *animationFile = [NSString stringWithFormat:@"%@-Animations.plist", typeAsString];
	NSString *idleAnimation = [NSString stringWithFormat:@"%@-Idle", typeAsString];
	
    // Transform
    TransformComponent *transformComponent = [TransformComponent componentWithPosition:CGPointMake(position.x, position.y)];
    [beeEntity addComponent:transformComponent];
    
    // Render
	RenderSystem *renderSystem = (RenderSystem *)[[world systemManager] getSystem:[RenderSystem class]];
	RenderSprite *renderSprite = [renderSystem createRenderSpriteWithSpriteSheetName:@"Sprites" animationFile:animationFile z:-3];
    RenderComponent *renderComponent = [RenderComponent componentWithRenderSprite:renderSprite];
    [beeEntity addComponent:renderComponent];
	
    // Physics
    cpBody *body = cpBodyNew(1.0f, 1.0f);
    body->v = cpv(velocity.x, velocity.y);
    CGPoint verts[] =
	{
        cpv(-2.0f, 6.0f),
        cpv(2.0f, 6.0f),
        cpv(6.0f, 2.0f),
        cpv(6.0f, -2.0f),
        cpv(2.0f, -6.0f),
        cpv(-2.0f, -6.0f),
        cpv(-6.0f, -2.0f),
        cpv(-6.0f, 2.0f)
    };
    cpShape *polyShape = cpPolyShapeNew(body, 8, verts, cpv(0, 0));
    polyShape->e = 0.8f;
    polyShape->u = 1.0f;
    polyShape->collision_type = COLLISION_TYPE_BEE;
    PhysicsBody *physicsBody = [PhysicsBody physicsBodyWithBody:body];
    PhysicsShape *physicsShape = [PhysicsShape physicsShapeWithShape:polyShape];
    PhysicsComponent *physicsComponent = [PhysicsComponent componentWithBody:physicsBody andShape:physicsShape];
    [beeEntity addComponent:physicsComponent];
	
    [beeEntity refresh];
	
	[renderComponent playAnimation:idleAnimation];
    
    return beeEntity;
}

+(Entity *) createBeeater:(World *)world withPosition:(CGPoint)position mirrored:(BOOL)mirrored
{
	Entity *beeaterEntity = [world createEntity];
	
	// Beeater
	BeeaterComponent *beeaterComponent = [BeeaterComponent component];
	[beeaterEntity addComponent:beeaterComponent];
	
    // Transform
    TransformComponent *transformComponent = [TransformComponent componentWithPosition:CGPointMake(position.x, position.y)];
    if (mirrored)
    {
        [transformComponent setScale:CGPointMake(-1.0f, 1.0f)];
    }
    [beeaterEntity addComponent:transformComponent];
	
    // Render
	RenderSystem *renderSystem = (RenderSystem *)[[world systemManager] getSystem:[RenderSystem class]];
	RenderSprite *bodyRenderSprite = [renderSystem createRenderSpriteWithSpriteSheetName:@"Sprites" animationFile:@"Beeater-Body-Animations.plist" z:-2];
	[[bodyRenderSprite sprite] setAnchorPoint:CGPointMake(0.6f, 0.0f)];
	RenderSprite *headRenderSprite = [renderSystem createRenderSpriteWithSpriteSheetName:@"Sprites" animationFile:@"Beeater-Head-Animations.plist" z:-1];
	[[headRenderSprite sprite] setAnchorPoint:CGPointMake(0.8f, -0.3f)];
    RenderComponent *renderComponent = [RenderComponent componentWithRenderSprites:[NSArray arrayWithObjects:bodyRenderSprite, headRenderSprite, nil]];
    [beeaterEntity addComponent:renderComponent];
	
    // Physics
    cpBody *body = cpBodyNew(1.0f, 1.0f);
    cpBodyInitStatic(body);
    CGPoint verts[] =
	{
        cpv(-15.0f, 0.0f),
        cpv(-15.0f, 40.0f),
        cpv(15.0f, 40.0f),
        cpv(15.0f, 0.0f)
    };
    cpShape *polyShape = cpPolyShapeNew(body, 4, verts, cpv(0, 0));
    polyShape->e = 0.8f;
    polyShape->u = 0.5f;
    polyShape->collision_type = COLLISION_TYPE_BEEATER;
    PhysicsBody *physicsBody = [PhysicsBody physicsBodyWithBody:body];
    PhysicsShape *physicsShape = [PhysicsShape physicsShapeWithShape:polyShape];
    PhysicsComponent *physicsComponent = [PhysicsComponent componentWithBody:physicsBody andShape:physicsShape];
    [beeaterEntity addComponent:physicsComponent];
	
    [beeaterEntity refresh];
	
    [bodyRenderSprite playAnimationsLoopAll:[NSArray arrayWithObjects:@"Beeater-Body-Idle", @"Beeater-Body-Wave", nil]];
    [headRenderSprite playAnimationsLoopAll:[NSArray arrayWithObjects:@"Beeater-Head-Idle", @"Beeater-Head-Lick", nil]];
    
    return beeaterEntity;
}

+(Entity *) createRamp:(World *)world withPosition:(CGPoint)position andRotation:(float)rotation
{
    Entity *rampEntity = [world createEntity];
    
    // Transform
    TransformComponent *transformComponent = [TransformComponent componentWithPosition:CGPointMake(position.x, position.y)];
    [rampEntity addComponent:transformComponent];
    
    // Render
	RenderSystem *renderSystem = (RenderSystem *)[[world systemManager] getSystem:[RenderSystem class]];
	RenderSprite *renderSprite = [renderSystem createRenderSpriteWithSpriteSheetName:@"Sprites" animationFile:@"Ramp-Animations.plist" z:-2];
    RenderComponent *renderComponent = [RenderComponent componentWithRenderSprite:renderSprite];
    [rampEntity addComponent:renderComponent];
	
    // Physics
    int num = 4;
    CGPoint verts[] =
	{
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
    PhysicsBody *physicsBody = [PhysicsBody physicsBodyWithBody:body];
    PhysicsShape *physicsShape = [PhysicsShape physicsShapeWithShape:shape];
    PhysicsComponent *physicsComponent = [PhysicsComponent componentWithBody:physicsBody andShape:physicsShape];
    [rampEntity addComponent:physicsComponent];
    
    [rampEntity refresh];
	
	[renderComponent playAnimation:@"Ramp-Idle"];
    
    return rampEntity;
}

+(Entity *) createPollen:(World *)world withPosition:(CGPoint)position
{
    Entity *pollenEntity = [world createEntity];
    
    // Transform
    TransformComponent *transformComponent = [TransformComponent componentWithPosition:CGPointMake(position.x, position.y)];
    [pollenEntity addComponent:transformComponent];
    
    // Render
    RenderSystem *renderSystem = (RenderSystem *)[[world systemManager] getSystem:[RenderSystem class]];
	RenderSprite *renderSprite = [renderSystem createRenderSpriteWithSpriteSheetName:@"Sprites" animationFile:@"Pollen-Animations.plist" z:-1];
    RenderComponent *renderComponent = [RenderComponent componentWithRenderSprite:renderSprite];
    [pollenEntity addComponent:renderComponent];
    
    // Physics
    cpBody *body = cpBodyNew(1.0f, 1.0f);
    cpBodyInitStatic(body);
    cpShape *shape = cpCircleShapeNew(body, 8, cpv(0, 0));
    cpShapeSetSensor(shape, TRUE);
    shape->e = 0.8f;
    shape->u = 0.5f;
    shape->collision_type = COLLISION_TYPE_POLLEN;
    PhysicsBody *physicsBody = [PhysicsBody physicsBodyWithBody:body];
    PhysicsShape *physicsShape = [PhysicsShape physicsShapeWithShape:shape];
    PhysicsComponent *physicsComponent = [PhysicsComponent componentWithBody:physicsBody andShape:physicsShape];
    [pollenEntity addComponent:physicsComponent];
    
    [pollenEntity refresh];
    
    [renderComponent playAnimation:@"Pollen-Idle"];
    
    return pollenEntity;
}

+(Entity *) createMushroom:(World *)world withPosition:(CGPoint)position
{
    Entity *mushroomEntity = [world createEntity];
    
    // Transform
    TransformComponent *transformComponent = [TransformComponent componentWithPosition:CGPointMake(position.x, position.y)];
    [mushroomEntity addComponent:transformComponent];
    
    // Render
    RenderSystem *renderSystem = (RenderSystem *)[[world systemManager] getSystem:[RenderSystem class]];
	RenderSprite *renderSprite = [renderSystem createRenderSpriteWithSpriteSheetName:@"Sprites" animationFile:@"Mushroom-Animations.plist" z:-1];
    [[renderSprite sprite] setAnchorPoint:CGPointMake(0.5f, 0.0f)];
    RenderComponent *renderComponent = [RenderComponent componentWithRenderSprite:renderSprite];
    [mushroomEntity addComponent:renderComponent];
    
    // Physics
    cpBody *body = cpBodyNew(1.0f, 1.0f);
    cpBodyInitStatic(body);
    cpShape *shape = cpCircleShapeNew(body, 25, cpv(0, 20));
    shape->e = 1.5f;
    shape->u = 0.5f;
    shape->collision_type = COLLISION_TYPE_MUSHROOM;
    PhysicsBody *physicsBody = [PhysicsBody physicsBodyWithBody:body];
    PhysicsShape *physicsShape = [PhysicsShape physicsShapeWithShape:shape];
    PhysicsComponent *physicsComponent = [PhysicsComponent componentWithBody:physicsBody andShape:physicsShape];
    [mushroomEntity addComponent:physicsComponent];
    
    [mushroomEntity refresh];
    
    [renderComponent playAnimation:@"Mushroom-Idle"];
    
    return mushroomEntity;
}

+(Entity *) createWood:(World *)world withPosition:(CGPoint)position
{
    Entity *woodEntity = [world createEntity];
    
    // Transform
    TransformComponent *transformComponent = [TransformComponent componentWithPosition:CGPointMake(position.x, position.y)];
    [woodEntity addComponent:transformComponent];
    
    // Render
    RenderSystem *renderSystem = (RenderSystem *)[[world systemManager] getSystem:[RenderSystem class]];
	RenderSprite *renderSprite = [renderSystem createRenderSpriteWithSpriteSheetName:@"Sprites" animationFile:@"Wood-Animations.plist" z:-1];
    [[renderSprite sprite] setAnchorPoint:CGPointMake(0.5f, 0.5f)];
    RenderComponent *renderComponent = [RenderComponent componentWithRenderSprite:renderSprite];
    [woodEntity addComponent:renderComponent];
    
    // Physics
    int num = 4;
    CGPoint verts[] =
	{
        CGPointMake(-5,-35),
        CGPointMake(-5, 35),
        CGPointMake( 5, 35),
        CGPointMake( 5,-35),
    };
    cpBody *body = cpBodyNew(1.0f, cpMomentForPoly(1.0f, num, verts, CGPointZero));
    cpBodyInitStatic(body);
    cpShape *shape = cpPolyShapeNew(body, num, verts, CGPointZero);
    shape->e = 0.8f;
    shape->u = 0.5f;
    shape->collision_type = COLLISION_TYPE_WOOD;
    PhysicsBody *physicsBody = [PhysicsBody physicsBodyWithBody:body];
    PhysicsShape *physicsShape = [PhysicsShape physicsShapeWithShape:shape];
    PhysicsComponent *physicsComponent = [PhysicsComponent componentWithBody:physicsBody andShape:physicsShape];
    [woodEntity addComponent:physicsComponent];
    
    [woodEntity refresh];
    
    [renderComponent playAnimation:@"Wood-Idle"];
    
    return woodEntity;
}

@end
