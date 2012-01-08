
//  EntityFactory.m
//  Beezle
//
//  Created by Me on 13/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EntityFactory.h"
#import "BeeaterComponent.h"
#import "BeeComponent.h"
#import "CollisionTypes.h"
#import "DisposableComponent.h"
#import "PhysicsComponent.h"
#import "PhysicsSystem.h"
#import "RenderComponent.h"
#import "RenderSprite.h"
#import "RenderSystem.h"
#import "SlingerComponent.h"
#import "TagManager.h"
#import "TrajectoryComponent.h"
#import "TransformComponent.h"

typedef enum
{
	Z_ORDER_BACKGROUND,
	Z_ORDER_BEEATER_BODY,
	Z_ORDER_BEEATER_HEAD,
	Z_ORDER_RAMP,
	Z_ORDER_POLLEN,
	Z_ORDER_MUSHROOM,
	Z_ORDER_WOOD,
	Z_ORDER_NUT,
	Z_ORDER_AIM_POLLEN,
	Z_ORDER_BEE,
	Z_ORDER_SLINGER,
} SortOrders;

@implementation EntityFactory

+(Entity *) createBackground:(World *)world withLevelName:(NSString *)name
{
    Entity *backgroundEntity = [world createEntity];
    
    // Transform
    TransformComponent *transformComponent = [TransformComponent component];
    [backgroundEntity addComponent:transformComponent];
    
    // Render
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGB565];
	RenderSystem *renderSystem = (RenderSystem *)[[world systemManager] getSystem:[RenderSystem class]];
    NSString *imageFileName = [NSString stringWithFormat:@"%@.jpg", name];
    RenderSprite *renderSprite = [renderSystem createRenderSpriteWithFile:imageFileName z:Z_ORDER_BACKGROUND];
    [renderSprite markAsBackground];
	RenderComponent *renderComponent = [RenderComponent componentWithRenderSprite:renderSprite];
    [backgroundEntity addComponent:renderComponent];
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
    
    // Physics
    PhysicsSystem *physicsSystem = (PhysicsSystem *)[[world systemManager] getSystem:[PhysicsSystem class]];
    NSString *shapesFileName = [NSString stringWithFormat:@"%@-Shapes.plist", name];
    PhysicsComponent *physicsComponent = [physicsSystem createPhysicsComponentWithFile:shapesFileName bodyName:name isStatic:TRUE collisionType:[CollisionTypes sharedTypeBackground]];
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
	ChipmunkBody *body = [ChipmunkBody bodyWithMass:1.0f andMoment:cpMomentForPoly(1.0f, num, verts, CGPointZero)];
	[body initStaticBody];
    NSMutableArray *shapes = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < num; i++)
    {
        int nextI = i == num - 1 ? 0 : i + 1;
		ChipmunkShape *shape = [ChipmunkSegmentShape segmentWithBody:body from:verts[i] to:verts[nextI] radius:0];
		[shape setElasticity:0.0f];
		[shape setFriction:0.5f];
		[shape setCollisionType:[CollisionTypes sharedTypeEdge]];
        
        [shapes addObject:shape];
    }
    PhysicsComponent *physicsComponent = [PhysicsComponent componentWithBody:body andShapes:shapes];
    [edgeEntity addComponent:physicsComponent];
    
    [edgeEntity refresh];
    
    return edgeEntity;
}

+(Entity *) createSlinger:(World *)world withBeeTypes:(NSArray *)beeTypes
{
    Entity *slingerEntity = [world createEntity];
	
	// Slinger
	SlingerComponent *slingerComponent = [SlingerComponent component];
    for (BeeTypes *beeType in beeTypes)
    {
        [slingerComponent pushBeeType:beeType];
    }
	[slingerEntity addComponent:slingerComponent];
    
    // Transform
    TransformComponent *transformComponent = [TransformComponent component];
    [slingerEntity addComponent:transformComponent];
	
	// Trajectory
	TrajectoryComponent *trajectoryComponent = [TrajectoryComponent component];
	[slingerEntity addComponent:trajectoryComponent];
	
    // Render
	RenderSystem *renderSystem = (RenderSystem *)[[world systemManager] getSystem:[RenderSystem class]];
	RenderSprite *renderSprite = [renderSystem createRenderSpriteWithSpriteSheetName:@"Sprites" animationFile:@"Sling-Animations.plist" z:Z_ORDER_SLINGER];
    [[renderSprite sprite] setAnchorPoint:CGPointMake(0.5f, 1.0f)];
    RenderComponent *renderComponent = [RenderComponent componentWithRenderSprite:renderSprite];
    [slingerEntity addComponent:renderComponent];
	
	TagManager *tagManager = (TagManager *)[world getManager:[TagManager class]];
	[tagManager registerEntity:slingerEntity withTag:@"SLINGER"];
	
	LabelManager *labelManager = (LabelManager *)[world getManager:[LabelManager class]];
	[labelManager labelEntity:slingerEntity withLabel:@"EDITABLE"];
    
    [slingerEntity refresh];
	
	[renderComponent playAnimation:@"Sling-Idle"];
    
    return slingerEntity;
}

+(Entity *) createBee:(World *)world withBeeType:(BeeTypes *)type andVelocity:(CGPoint)velocity
{
    Entity *beeEntity = [world createEntity];
	
    // Bee
	BeeComponent *beeComponent = [BeeComponent componentWithType:type];
	[beeEntity addComponent:beeComponent];
	
    // Transform
    TransformComponent *transformComponent = [TransformComponent component];
    [beeEntity addComponent:transformComponent];
    
    // Render
	RenderSystem *renderSystem = (RenderSystem *)[[world systemManager] getSystem:[RenderSystem class]];
    NSString *animationFile = [NSString stringWithFormat:@"%@-Animations.plist", [type capitalizedString]];
	RenderSprite *renderSprite = [renderSystem createRenderSpriteWithSpriteSheetName:@"Sprites" animationFile:animationFile z:Z_ORDER_BEE];
    RenderComponent *renderComponent = [RenderComponent componentWithRenderSprite:renderSprite];
    [beeEntity addComponent:renderComponent];
	
    // Physics
	ChipmunkBody *body = [ChipmunkBody bodyWithMass:1.0f andMoment:1.0f];
	[body setVel:velocity];
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
	ChipmunkShape *shape = [ChipmunkPolyShape polyWithBody:body count:8 verts:verts offset:CGPointZero];
	[shape setElasticity:0.8f];
	[shape setFriction:1.0f];
	[shape setCollisionType:[CollisionTypes sharedTypeBee]];
    PhysicsComponent *physicsComponent = [PhysicsComponent componentWithBody:body andShape:shape];
    [beeEntity addComponent:physicsComponent];
    
    // Disposable
    DisposableComponent *disposableComponent = [DisposableComponent component];
    [beeEntity addComponent:disposableComponent];
    
    GroupManager *groupManager = (GroupManager *)[world getManager:[GroupManager class]];
    [groupManager addEntity:beeEntity toGroup:@"BEES"];
	
    [beeEntity refresh];
	
    NSString *idleAnimationName = [NSString stringWithFormat:@"%@-Idle", [type capitalizedString]];
	[renderComponent playAnimation:idleAnimationName];
    
    return beeEntity;
}

+(Entity *) createBeeater:(World *)world withBeeType:(BeeTypes *)beeType
{
	Entity *beeaterEntity = [world createEntity];
	
	// Beeater
	BeeaterComponent *beeaterComponent = [BeeaterComponent component];
    [beeaterComponent setContainedBeeType:beeType];
	[beeaterEntity addComponent:beeaterComponent];
	
    // Transform
    TransformComponent *transformComponent = [TransformComponent component];
    [beeaterEntity addComponent:transformComponent];
	
    // Render
	RenderSystem *renderSystem = (RenderSystem *)[[world systemManager] getSystem:[RenderSystem class]];
	RenderSprite *bodyRenderSprite = [renderSystem createRenderSpriteWithSpriteSheetName:@"Sprites" animationFile:@"Beeater-Body-Animations.plist" z:Z_ORDER_BEEATER_BODY];
	[[bodyRenderSprite sprite] setAnchorPoint:CGPointMake(0.6f, 0.0f)];
	RenderSprite *headRenderSprite = [renderSystem createRenderSpriteWithSpriteSheetName:@"Sprites" animationFile:@"Beeater-Head-Animations.plist" z:Z_ORDER_BEEATER_HEAD];
	[[headRenderSprite sprite] setAnchorPoint:CGPointMake(0.8f, -0.3f)];
    RenderComponent *renderComponent = [RenderComponent component];
    [renderComponent addRenderSprite:bodyRenderSprite withName:@"body"];
    [renderComponent addRenderSprite:headRenderSprite withName:@"head"];
    [beeaterEntity addComponent:renderComponent];
	
    // Physics
	ChipmunkBody *body = [ChipmunkBody bodyWithMass:1.0f andMoment:1.0f];
	[body initStaticBody];
    CGPoint verts[] =
	{
        cpv(-15.0f, 0.0f),
        cpv(-15.0f, 40.0f),
        cpv(15.0f, 40.0f),
        cpv(15.0f, 0.0f)
    };
	ChipmunkShape *shape = [ChipmunkPolyShape polyWithBody:body count:4 verts:verts offset:CGPointZero];
	[shape setElasticity:0.8f];
	[shape setFriction:0.5f];
	[shape setCollisionType:[CollisionTypes sharedTypeBeeater]];
    PhysicsComponent *physicsComponent = [PhysicsComponent componentWithBody:body andShape:shape];
    [beeaterEntity addComponent:physicsComponent];
    
    // Disposable
    DisposableComponent *disposableComponent = [DisposableComponent component];
    [beeaterEntity addComponent:disposableComponent];
	
    GroupManager *groupManager = (GroupManager *)[world getManager:[GroupManager class]];
    [groupManager addEntity:beeaterEntity toGroup:@"BEEATERS"];
	
	LabelManager *labelManager = (LabelManager *)[world getManager:[LabelManager class]];
	[labelManager labelEntity:beeaterEntity withLabel:@"EDITABLE"];
    
    [beeaterEntity refresh];
	
    [bodyRenderSprite playAnimationsLoopAll:[NSArray arrayWithObjects:@"Beeater-Body-Idle", @"Beeater-Body-Wave", nil]];
	NSString *headAnimationName = [NSString stringWithFormat:@"Beeater-Head-Idle-With%@", [beeType capitalizedString]];
    [headRenderSprite playAnimation:headAnimationName];
    
    return beeaterEntity;
}

+(Entity *) createRamp:(World *)world
{
    Entity *rampEntity = [world createEntity];
    
    // Transform
    TransformComponent *transformComponent = [TransformComponent component];
    [rampEntity addComponent:transformComponent];
    
    // Render
	RenderSystem *renderSystem = (RenderSystem *)[[world systemManager] getSystem:[RenderSystem class]];
	RenderSprite *renderSprite = [renderSystem createRenderSpriteWithSpriteSheetName:@"Sprites" animationFile:@"Ramp-Animations.plist" z:Z_ORDER_RAMP];
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
	ChipmunkBody *body = [ChipmunkBody bodyWithMass:1.0f andMoment:cpMomentForPoly(1.0f, num, verts, CGPointZero)];
	[body initStaticBody];
	ChipmunkShape *shape = [ChipmunkPolyShape polyWithBody:body count:num verts:verts offset:CGPointZero];
	[shape setElasticity:0.8f];
	[shape setFriction:0.5f];
	[shape setCollisionType:[CollisionTypes sharedTypeRamp]];
    PhysicsComponent *physicsComponent = [PhysicsComponent componentWithBody:body andShape:shape];
    [rampEntity addComponent:physicsComponent];
    
    // Disposable
    DisposableComponent *disposableComponent = [DisposableComponent component];
    [rampEntity addComponent:disposableComponent];
	
	LabelManager *labelManager = (LabelManager *)[world getManager:[LabelManager class]];
	[labelManager labelEntity:rampEntity withLabel:@"EDITABLE"];
	[labelManager labelEntity:rampEntity withLabel:@"RAMP"];
    
    [rampEntity refresh];
	
	[renderComponent playAnimation:@"Ramp-Idle"];
    
    return rampEntity;
}

+(Entity *) createPollen:(World *)world
{
    Entity *pollenEntity = [world createEntity];
    
    // Transform
    TransformComponent *transformComponent = [TransformComponent component];
    [pollenEntity addComponent:transformComponent];
    
    // Render
    RenderSystem *renderSystem = (RenderSystem *)[[world systemManager] getSystem:[RenderSystem class]];
	RenderSprite *renderSprite = [renderSystem createRenderSpriteWithSpriteSheetName:@"Sprites" animationFile:@"Pollen-Animations.plist" z:Z_ORDER_POLLEN];
    RenderComponent *renderComponent = [RenderComponent componentWithRenderSprite:renderSprite];
    [pollenEntity addComponent:renderComponent];
    
    // Physics
	ChipmunkBody *body = [ChipmunkBody bodyWithMass:1.0f andMoment:1.0f];
	[body initStaticBody];
	ChipmunkShape *shape = [ChipmunkCircleShape circleWithBody:body radius:8 offset:CGPointZero];
	[shape setElasticity:0.8f];
	[shape setFriction:0.5f];
	[shape setCollisionType:[CollisionTypes sharedTypePollen]];
    PhysicsComponent *physicsComponent = [PhysicsComponent componentWithBody:body andShape:shape];
    [pollenEntity addComponent:physicsComponent];
    
    // Disposable
    DisposableComponent *disposableComponent = [DisposableComponent component];
    [pollenEntity addComponent:disposableComponent];
	
	LabelManager *labelManager = (LabelManager *)[world getManager:[LabelManager class]];
	[labelManager labelEntity:pollenEntity withLabel:@"EDITABLE"];
    
    [pollenEntity refresh];
    
    [renderComponent playAnimation:@"Pollen-Idle"];
    
    return pollenEntity;
}

+(Entity *) createMushroom:(World *)world
{
    Entity *mushroomEntity = [world createEntity];
    
    // Transform
    TransformComponent *transformComponent = [TransformComponent component];
    [mushroomEntity addComponent:transformComponent];
    
    // Render
    RenderSystem *renderSystem = (RenderSystem *)[[world systemManager] getSystem:[RenderSystem class]];
	RenderSprite *renderSprite = [renderSystem createRenderSpriteWithSpriteSheetName:@"Sprites" animationFile:@"Mushroom-Animations.plist" z:Z_ORDER_MUSHROOM];
    [[renderSprite sprite] setAnchorPoint:CGPointMake(0.5f, 0.0f)];
    RenderComponent *renderComponent = [RenderComponent componentWithRenderSprite:renderSprite];
    [mushroomEntity addComponent:renderComponent];
    
    // Physics
	ChipmunkBody *body = [ChipmunkBody bodyWithMass:1.0f andMoment:1.0f];
	[body initStaticBody];
	ChipmunkShape *shape = [ChipmunkCircleShape circleWithBody:body radius:25 offset:cpv(0, 20)];
	[shape setElasticity:1.5f];
	[shape setFriction:0.5f];
	[shape setCollisionType:[CollisionTypes sharedTypeMushroom]];
    PhysicsComponent *physicsComponent = [PhysicsComponent componentWithBody:body andShape:shape];
    [mushroomEntity addComponent:physicsComponent];
	
	LabelManager *labelManager = (LabelManager *)[world getManager:[LabelManager class]];
	[labelManager labelEntity:mushroomEntity withLabel:@"EDITABLE"];
    
    [mushroomEntity refresh];
    
    [renderComponent playAnimation:@"Mushroom-Idle"];
    
    return mushroomEntity;
}

+(Entity *) createWood:(World *)world
{
    Entity *woodEntity = [world createEntity];
    
    // Transform
    TransformComponent *transformComponent = [TransformComponent component];
    [woodEntity addComponent:transformComponent];
    
    // Render
    RenderSystem *renderSystem = (RenderSystem *)[[world systemManager] getSystem:[RenderSystem class]];
	RenderSprite *renderSprite = [renderSystem createRenderSpriteWithSpriteSheetName:@"Sprites" animationFile:@"Wood-Animations.plist" z:Z_ORDER_WOOD];
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
	ChipmunkBody *body = [ChipmunkBody bodyWithMass:1.0f andMoment:cpMomentForPoly(1.0f, num, verts, CGPointZero)];
	[body initStaticBody];
	ChipmunkShape *shape = [ChipmunkPolyShape polyWithBody:body count:num verts:verts offset:CGPointZero];
	[shape setElasticity:0.8f];
	[shape setFriction:0.5f];
	[shape setCollisionType:[CollisionTypes sharedTypeWood]];
    PhysicsComponent *physicsComponent = [PhysicsComponent componentWithBody:body andShape:shape];
    [woodEntity addComponent:physicsComponent];
    
    // Disposable
    DisposableComponent *disposableComponent = [DisposableComponent component];
    [woodEntity addComponent:disposableComponent];
	
	LabelManager *labelManager = (LabelManager *)[world getManager:[LabelManager class]];
	[labelManager labelEntity:woodEntity withLabel:@"EDITABLE"];
    
    [woodEntity refresh];
    
    [renderComponent playAnimation:@"Wood-Idle"];
    
    return woodEntity;
}

+(Entity *) createNut:(World *)world
{
    Entity *nutEntity = [world createEntity];
    
    // Transform
    TransformComponent *transformComponent = [TransformComponent component];
    [nutEntity addComponent:transformComponent];
    
    // Render
    RenderSystem *renderSystem = (RenderSystem *)[[world systemManager] getSystem:[RenderSystem class]];
	RenderSprite *renderSprite = [renderSystem createRenderSpriteWithSpriteSheetName:@"Sprites" animationFile:@"Nut-Animations.plist" z:Z_ORDER_NUT];
    [[renderSprite sprite] setAnchorPoint:CGPointMake(0.5f, 0.0f)];
    RenderComponent *renderComponent = [RenderComponent componentWithRenderSprite:renderSprite];
    [nutEntity addComponent:renderComponent];
    
    // Physics
	ChipmunkBody *body = [ChipmunkBody bodyWithMass:1.0f andMoment:1.0f];
	[body initStaticBody];
	ChipmunkShape *shape = [ChipmunkCircleShape circleWithBody:body radius:20 offset:cpv(0, 20)];
	[shape setElasticity:1.5f];
	[shape setFriction:0.5f];
	[shape setCollisionType:[CollisionTypes sharedTypeNut]];
    PhysicsComponent *physicsComponent = [PhysicsComponent componentWithBody:body andShape:shape];
    [nutEntity addComponent:physicsComponent];
    
    // Disposable
    DisposableComponent *disposableComponent = [DisposableComponent component];
    [nutEntity addComponent:disposableComponent];
	
	LabelManager *labelManager = (LabelManager *)[world getManager:[LabelManager class]];
	[labelManager labelEntity:nutEntity withLabel:@"EDITABLE"];
    
    [nutEntity refresh];
    
    [renderComponent playAnimation:@"Nut-Idle"];
    
    return nutEntity;
}

+(Entity *) createAimPollen:(World *)world withVelocity:(CGPoint)velocity
{
    Entity *aimPollenEntity = [world createEntity];
	
    // Transform
    TransformComponent *transformComponent = [TransformComponent component];
    [transformComponent setScale:CGPointMake(0.33f, 0.33f)];
    [aimPollenEntity addComponent:transformComponent];
    
    // Render
    RenderSystem *renderSystem = (RenderSystem *)[[world systemManager] getSystem:[RenderSystem class]];
	RenderSprite *renderSprite = [renderSystem createRenderSpriteWithSpriteSheetName:@"Sprites" animationFile:@"Pollen-Animations.plist" z:Z_ORDER_AIM_POLLEN];
    RenderComponent *renderComponent = [RenderComponent componentWithRenderSprite:renderSprite];
    [aimPollenEntity addComponent:renderComponent];
	
    // Physics
	ChipmunkBody *body = [ChipmunkBody bodyWithMass:1.0f andMoment:1.0f];
	[body setVel:velocity];
	int num = 8;
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
	ChipmunkShape *shape = [ChipmunkPolyShape polyWithBody:body count:num verts:verts offset:CGPointZero];
	[shape setElasticity:0.8f];
	[shape setFriction:1.0f];
	[shape setCollisionType:[CollisionTypes sharedTypeAimPollen]];
	[shape setGroup:[CollisionTypes sharedTypeAimPollen]];
    PhysicsComponent *physicsComponent = [PhysicsComponent componentWithBody:body andShape:shape];
    [aimPollenEntity addComponent:physicsComponent];
    
    // Disposable
    DisposableComponent *disposableComponent = [DisposableComponent component];
    [aimPollenEntity addComponent:disposableComponent];
	
    [aimPollenEntity refresh];
	
	[renderComponent playAnimation:@"Pollen-Idle"];
    
    CCFadeOut *fadeOutAction = [CCFadeOut actionWithDuration:0.8f];
    CCCallFunc *callFunctionAction = [CCCallFunc actionWithTarget:aimPollenEntity selector:@selector(deleteEntity)];
    [[renderSprite sprite] runAction:[CCSequence actions:fadeOutAction, callFunctionAction, nil]];
    
    return aimPollenEntity;
}

@end
