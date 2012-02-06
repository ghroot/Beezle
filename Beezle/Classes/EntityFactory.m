
//  EntityFactory.m
//  Beezle
//
//  Created by Me on 13/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EntityFactory.h"
#import "BeeaterComponent.h"
#import "BeeComponent.h"
#import "CollisionType.h"
#import "DisposableComponent.h"
#import "EditComponent.h"
#import "EntityDescriptionCache.h"
#import "EntityDescriptionLoader.h"
#import "MovementComponent.h"
#import "PhysicsComponent.h"
#import "PhysicsSystem.h"
#import "RenderComponent.h"
#import "RenderSprite.h"
#import "RenderSystem.h"
#import "SlingerComponent.h"
#import "TagManager.h"
#import "TrajectoryComponent.h"
#import "TransformComponent.h"

@implementation EntityFactory

+(Entity *) createEntity:(NSString *)type world:(World *)world
{
	Entity *entity = [world createEntity];
	
	EntityDescription *entityDescription = [[EntityDescriptionCache sharedCache] entityDescriptionByType:type];
	if (entityDescription == nil)
	{
		entityDescription = [[EntityDescriptionLoader sharedLoader] loadEntityDescription:type];
		[[EntityDescriptionCache sharedCache] addEntityDescription:entityDescription];
	}
	
	NSArray *components = [entityDescription createComponents:world];
	for (Component *component in components)
	{
		[entity addComponent:component];
	}
	
	[entity refresh];
	
	return entity;
}

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
    PhysicsComponent *physicsComponent = [physicsSystem createPhysicsComponentWithFile:shapesFileName bodyName:name collisionType:[CollisionType BACKGROUND]];
    [backgroundEntity addComponent:physicsComponent];
    
    [backgroundEntity refresh];
    
    return backgroundEntity;    
}

+(Entity *) createEdge:(World *)world
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    Entity *edgeEntity = [world createEntity];
    
    // Transform
    TransformComponent *transformComponent = [TransformComponent componentWithPosition:CGPointZero];
    [edgeEntity addComponent:transformComponent];
    
    // Physics
    int num = 4;
    CGPoint verts[] = {
        cpv(0.0f, 0.0f),
        cpv(winSize.width, 0.0f),
        cpv(winSize.width, winSize.height),
        cpv(0.0f, winSize.height)
    };
	ChipmunkBody *body = [ChipmunkBody staticBody];
    NSMutableArray *shapes = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < num; i++)
    {
        int nextI = i == num - 1 ? 0 : i + 1;
		ChipmunkShape *shape = [ChipmunkSegmentShape segmentWithBody:body from:verts[i] to:verts[nextI] radius:0];
		[shape setElasticity:0.0f];
		[shape setFriction:0.5f];
		[shape setCollisionType:[CollisionType EDGE]];
        
        [shapes addObject:shape];
    }
    PhysicsComponent *physicsComponent = [PhysicsComponent componentWithBody:body andShapes:shapes];
    [edgeEntity addComponent:physicsComponent];
    
    [edgeEntity refresh];
    
    return edgeEntity;
}

+(Entity *) createSlinger:(World *)world withBeeTypes:(NSArray *)beeTypes
{
    Entity *slingerEntity = [self createEntity:@"SLINGER" world:world];
	
	SlingerComponent *slingerComponent = [SlingerComponent getFrom:slingerEntity];
    for (BeeType *beeType in beeTypes)
    {
        [slingerComponent pushBeeType:beeType];
    }
	
	TagManager *tagManager = (TagManager *)[world getManager:[TagManager class]];
	[tagManager registerEntity:slingerEntity withTag:@"SLINGER"];
	
	[[RenderComponent getFrom:slingerEntity] playAnimation:@"Sling-Idle"];
    
    return slingerEntity;
}

+(Entity *) createBee:(World *)world withBeeType:(BeeType *)type andVelocity:(CGPoint)velocity
{
    Entity *beeEntity = nil;
	if (type == [BeeType BEE])
	{
		beeEntity = [self createEntity:@"Bee" world:world];
	}
	else if (type == [BeeType BOMBEE])
	{
		beeEntity = [self createEntity:@"Bombee" world:world];
	}
	else if (type == [BeeType SAWEE])
	{
		beeEntity = [self createEntity:@"Sawee" world:world];
	}
	else if (type == [BeeType SPEEDEE])
	{
		beeEntity = [self createEntity:@"Speedee" world:world];
	}
	
	BeeComponent *beeComponent = [BeeComponent getFrom:beeEntity];
	[beeComponent setType:type];
	
	PhysicsComponent *physicsComponent = [PhysicsComponent getFrom:beeEntity];
	[[physicsComponent body] setVel:velocity];
    
    GroupManager *groupManager = (GroupManager *)[world getManager:[GroupManager class]];
    [groupManager addEntity:beeEntity toGroup:@"BEES"];
    
    return beeEntity;
}

+(Entity *) createBeeater:(World *)world withBeeType:(BeeType *)beeType
{	
	Entity *beeaterEntity = [self createEntity:@"Beeater" world:world];
	
	[[BeeaterComponent getFrom:beeaterEntity] setContainedBeeType:beeType];
	
    GroupManager *groupManager = (GroupManager *)[world getManager:[GroupManager class]];
    [groupManager addEntity:beeaterEntity toGroup:@"BEEATERS"];
	
	RenderSprite *bodyRenderSprite = [[RenderComponent getFrom:beeaterEntity] getRenderSprite:@"body"];
	RenderSprite *headRenderSprite = [[RenderComponent getFrom:beeaterEntity] getRenderSprite:@"head"];
    [bodyRenderSprite playAnimationsLoopAll:[NSArray arrayWithObjects:@"Beeater-Body-Idle", @"Beeater-Body-Wave", nil]];
	NSString *headAnimationName = [NSString stringWithFormat:@"Beeater-Head-Idle-With%@", [beeType capitalizedString]];
    [headRenderSprite playAnimation:headAnimationName];
    
    return beeaterEntity;
}

+(Entity *) createBeeaterCeiling:(World *)world withBeeType:(BeeType *)beeType
{
	Entity *beeaterCeilingEntity = [self createEntity:@"Beeater-Ceiling" world:world];
	
	[[BeeaterComponent getFrom:beeaterCeilingEntity] setContainedBeeType:beeType];
	
    GroupManager *groupManager = (GroupManager *)[world getManager:[GroupManager class]];
    [groupManager addEntity:beeaterCeilingEntity toGroup:@"BEEATERS"];
	
	RenderSprite *bodyRenderSprite = [[RenderComponent getFrom:beeaterCeilingEntity] getRenderSprite:@"body"];
	RenderSprite *headRenderSprite = [[RenderComponent getFrom:beeaterCeilingEntity] getRenderSprite:@"head"];
    [bodyRenderSprite playAnimationsLoopAll:[NSArray arrayWithObjects:@"Beeater-Body-Ceiling-Idle", @"Beeater-Body-Ceiling-Wave", nil]];
	NSString *headAnimationName = [NSString stringWithFormat:@"Beeater-Head-Idle-With%@", [beeType capitalizedString]];
    [headRenderSprite playAnimation:headAnimationName];
    
    return beeaterCeilingEntity;
}

+(Entity *) createBeeaterBird:(World *)world withBeeType:(BeeType *)beeType
{
	Entity *beeaterBirdEntity = [self createEntity:@"Beeater-Bird" world:world];
	
	[[BeeaterComponent getFrom:beeaterBirdEntity] setContainedBeeType:beeType];
	
    GroupManager *groupManager = (GroupManager *)[world getManager:[GroupManager class]];
    [groupManager addEntity:beeaterBirdEntity toGroup:@"BEEATERS"];
	
	RenderSprite *bodyRenderSprite = [[RenderComponent getFrom:beeaterBirdEntity] getRenderSprite:@"body"];
	RenderSprite *headRenderSprite = [[RenderComponent getFrom:beeaterBirdEntity] getRenderSprite:@"head"];
    [bodyRenderSprite playAnimation:@"Beeater-Body-Bird-Idle"];
	NSString *headAnimationName = [NSString stringWithFormat:@"Beeater-Head-Idle-With%@", [beeType capitalizedString]];
    [headRenderSprite playAnimation:headAnimationName];
    
    return beeaterBirdEntity;
}

+(Entity *) createBeeaterFish:(World *)world withBeeType:(BeeType *)beeType
{
	Entity *beeaterFishEntity = [self createEntity:@"Beeater-Fish" world:world];
	
	[[BeeaterComponent getFrom:beeaterFishEntity] setContainedBeeType:beeType];
	
    GroupManager *groupManager = (GroupManager *)[world getManager:[GroupManager class]];
    [groupManager addEntity:beeaterFishEntity toGroup:@"BEEATERS"];
	
	RenderSprite *bodyRenderSprite = [[RenderComponent getFrom:beeaterFishEntity] getRenderSprite:@"body"];
	RenderSprite *headRenderSprite = [[RenderComponent getFrom:beeaterFishEntity] getRenderSprite:@"head"];
    [bodyRenderSprite playAnimation:@"Beeater-Body-Fish-Idle"];
	NSString *headAnimationName = [NSString stringWithFormat:@"Beeater-Head-Idle-With%@", [beeType capitalizedString]];
    [headRenderSprite playAnimation:headAnimationName];
    
    return beeaterFishEntity;
}

+(Entity *) createRamp:(World *)world
{
    Entity *rampEntity = [self createEntity:@"Ramp" world:world];
	
	LabelManager *labelManager = (LabelManager *)[world getManager:[LabelManager class]];
	[labelManager labelEntity:rampEntity withLabel:@"RAMP"];
	
	[[RenderComponent getFrom:rampEntity] playAnimation:@"Ramp-Idle"];
    
    return rampEntity;
}

+(Entity *) createPollen:(World *)world
{
    Entity *pollenEntity = [self createEntity:@"Pollen" world:world];
    
    [[RenderComponent getFrom:pollenEntity] playAnimation:@"Pollen-Idle"];
    
    return pollenEntity;
}

+(Entity *) createMushroom:(World *)world
{
    Entity *mushroomEntity = [self createEntity:@"Mushroom" world:world];
    
    [[RenderComponent getFrom:mushroomEntity] playAnimation:@"Mushroom-Idle"];
    
    return mushroomEntity;
}

+(Entity *) createSmokeMushroom:(World *)world
{
    Entity *smokeMushroomEntity = [self createEntity:@"SmokeMushroom" world:world];
    
    [[RenderComponent getFrom:smokeMushroomEntity] playAnimation:@"SmokeMushroom-Idle"];
    
    return smokeMushroomEntity;
}

+(Entity *) createWood:(World *)world
{
    Entity *woodEntity = [self createEntity:@"Wood" world:world];
    
    [[RenderComponent getFrom:woodEntity] playAnimation:@"Wood-Idle"];
    
    return woodEntity;
}

+(Entity *) createNut:(World *)world
{
    return [self createEntity:@"Nut" world:world];
}

+(Entity *) createEgg:(World *)world
{
    return [self createEntity:@"Egg" world:world];
}

+(Entity *) createAimPollen:(World *)world withVelocity:(CGPoint)velocity
{
    Entity *aimPollenEntity = [self createEntity:@"AimPollen" world:world];
	
	PhysicsComponent *physicsComponent = [PhysicsComponent getFrom:aimPollenEntity];
	[[physicsComponent body] setVel:velocity];
    
	RenderComponent *renderComponent = [RenderComponent getFrom:aimPollenEntity];
	RenderSprite *renderSprite = [[renderComponent renderSprites] objectAtIndex:0];
    CCFadeOut *fadeOutAction = [CCFadeOut actionWithDuration:0.8f];
    CCCallFunc *callFunctionAction = [CCCallFunc actionWithTarget:aimPollenEntity selector:@selector(deleteEntity)];
    [[renderSprite sprite] runAction:[CCSequence actions:fadeOutAction, callFunctionAction, nil]];
    
    return aimPollenEntity;
}

+(Entity *) createLeaf:(World *)world withMovePositions:(NSArray *)movePositions
{
	Entity *leafEntity = [self createEntity:@"Leaf" world:world];
    
	// Movement
	MovementComponent *movementComponent = [MovementComponent getFrom:leafEntity];
	[movementComponent setPositions:[NSArray arrayWithArray:movePositions]];
    
    return leafEntity;
}

+(Entity *) createHangNest:(World *)world withMovePositions:(NSArray *)movePositions
{
	Entity *hangNestEntity = [self createEntity:@"HangNest" world:world];
	
	MovementComponent *movementComponent = [MovementComponent getFrom:hangNestEntity];
	[movementComponent setPositions:[NSArray arrayWithArray:movePositions]];
    
    return hangNestEntity;
}

+(Entity *) createMovementIndicator:(World *)world forEntity:(Entity *)entity
{
	Entity *movementIndicatorEntity = [world createEntity];
	
    // Transform
    TransformComponent *transformComponent = [TransformComponent component];
	[transformComponent setScale:CGPointMake(0.5f, 0.5f)];
    [movementIndicatorEntity addComponent:transformComponent];
	
    // Render (TODO: Copy render component from main entity)
	RenderSystem *renderSystem = (RenderSystem *)[[world systemManager] getSystem:[RenderSystem class]];
//	if ([[[RenderComponent getFrom:entity] renderSprites] count] == 1)
//	{
//		RenderSprite *renderSprite = [renderSystem createRenderSpriteWithSpriteSheetName:@"Sprites" animationFile:@"Leaf-Animations.plist" z:Z_ORDER_LEAF];
//		[[renderSprite sprite] setOpacity:128];
//		RenderComponent *renderComponent = [RenderComponent componentWithRenderSprite:renderSprite];
//		[movementIndicatorEntity addComponent:renderComponent];
//		
//		[renderComponent playAnimation:@"Leaf-Idle"];
//	}
//	else
//	{
//		RenderSprite *mainRenderSprite = [renderSystem createRenderSpriteWithSpriteSheetName:@"Sprites" animationFile:@"HangNest-Animations.plist" z:Z_ORDER_HANGNEST];
//		[[mainRenderSprite sprite] setAnchorPoint:CGPointMake(0.6f, 0.0f)];
//		[[mainRenderSprite sprite] setOpacity:128];
//		RenderSprite *lianRenderSprite = [renderSystem createRenderSpriteWithSpriteSheetName:@"Sprites" animationFile:@"HangNestLian-Animations.plist" z:Z_ORDER_HANGNEST_LIAN];
//		[[lianRenderSprite sprite] setAnchorPoint:CGPointMake(0.8f, -0.3f)];
//		[[lianRenderSprite sprite] setOpacity:128];
//		RenderComponent *renderComponent = [RenderComponent component];
//		[renderComponent addRenderSprite:mainRenderSprite withName:@"main"];
//		[renderComponent addRenderSprite:lianRenderSprite withName:@"lian"];
//		[movementIndicatorEntity addComponent:renderComponent];
//		
//		[mainRenderSprite playAnimation:@"HangNest-Idle"];
//		[lianRenderSprite playAnimation:@"HangNestLian-Idle"];
//	}
	RenderSprite *renderSprite = [renderSystem createRenderSpriteWithSpriteSheetName:@"Sprites" animationFile:@"Pollen-Animations.plist" z:10];
	[renderSprite playAnimation:@"Pollen-Idle"];
	[[renderSprite sprite] setOpacity:128];
	RenderComponent *renderComponent = [RenderComponent componentWithRenderSprite:renderSprite];
	[movementIndicatorEntity addComponent:renderComponent];
	
	// Edit
	EditComponent *editComponent = [EditComponent component];
	[movementIndicatorEntity addComponent:editComponent];
	
	[movementIndicatorEntity refresh];
	
	return movementIndicatorEntity;
}

@end
