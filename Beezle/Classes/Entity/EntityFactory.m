
//  EntityFactory.m
//  Beezle
//
//  Created by Me on 13/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EntityFactory.h"
#import "BeeComponent.h"
#import "BeeType.h"
#import "BodyInfo.h"
#import "CollisionGroup.h"
#import "EditComponent.h"
#import "EntityDescription.h"
#import "EntityDescriptionCache.h"
#import "EntityDescriptionLoader.h"
#import "EntityUtil.h"
#import "LevelLayoutEntry.h"
#import "LevelOrganizer.h"
#import "PhysicsComponent.h"
#import "PhysicsSystem.h"
#import "RenderComponent.h"
#import "RenderSprite.h"
#import "RenderSystem.h"
#import "SolidComponent.h"
#import "SoundComponent.h"
#import "SpawnComponent.h"
#import "TransformComponent.h"
#import "VoidComponent.h"
#import "WaterComponent.h"
#import "Waves1DNode.h"

#define BACKGROUND_FRICTION 0.7f
#define BACKGROUND_ELASTICITY 0.7f
#define BACKGROUND_LAYERS 7
#define EDGE_FRICTION 0.5f
#define EDGE_ELASTICITY 0.0f
#define EDGE_LAYERS 7
#define AIM_POLLEN_LAYERS 2

@interface EntityFactory()

+(EntityDescription *) getEntityDescription:(NSString *)type;

@end

@implementation EntityFactory

+(Entity *) createEdge:(World *)world
{
	Entity *edgeEntity = [world createEntity];
	
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
	// Transform
    TransformComponent *transformComponent = [TransformComponent component];
    [edgeEntity addComponent:transformComponent];
	
	// Physics
	ChipmunkBody *body = [ChipmunkBody staticBody];
	NSMutableArray *shapes = [NSMutableArray array];
	int numEdgeVerts = 4;
    CGPoint edgeVerts[] = {
        cpv(-winSize.width / 2, -winSize.height / 2),
        cpv(winSize.width / 2, -winSize.height / 2),
        cpv(winSize.width / 2, winSize.height / 2),
        cpv(-winSize.width / 2, winSize.height / 2)
    };
    for (int i = 0; i < numEdgeVerts; i++)
    {
        int nextI = i == numEdgeVerts - 1 ? 0 : i + 1;
		ChipmunkShape *shape = [ChipmunkSegmentShape segmentWithBody:body from:edgeVerts[i] to:edgeVerts[nextI] radius:0];
		[shape setFriction:EDGE_FRICTION];
		[shape setElasticity:EDGE_ELASTICITY];
		[shape setLayers:EDGE_LAYERS];
		[shape setGroup:[CollisionGroup LEVEL]];
        [shapes addObject:shape];
    }
	PhysicsComponent *physicsComponent = [PhysicsComponent componentWithBody:body andShapes:shapes];
    [edgeEntity addComponent:physicsComponent];
	
    // Void
	VoidComponent *voidComponent = [VoidComponent component];
	[voidComponent setInstant:TRUE];
    [edgeEntity addComponent:voidComponent];
	
	[edgeEntity refresh];
	
	[EntityUtil setEntityPosition:edgeEntity position:CGPointMake(winSize.width / 2, winSize.height / 2)];
	
	return edgeEntity;
}

+(Entity *) createBackground:(World *)world withLevelName:(NSString *)name
{
    Entity *backgroundEntity = [world createEntity];
	
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
    // Transform
    TransformComponent *transformComponent = [TransformComponent component];
    [backgroundEntity addComponent:transformComponent];
    
    // Render
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGB565];
	RenderSystem *renderSystem = (RenderSystem *)[[world systemManager] getSystem:[RenderSystem class]];
    NSString *imageFileName = [NSString stringWithFormat:@"%@.jpg", name];
    RenderSprite *renderSprite = [renderSystem createRenderSpriteWithFile:imageFileName z:1];
    [renderSprite markAsBackground];
	RenderComponent *renderComponent = [RenderComponent componentWithRenderSprite:renderSprite];
    [backgroundEntity addComponent:renderComponent];
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
    
    // Physics
    PhysicsSystem *physicsSystem = (PhysicsSystem *)[[world systemManager] getSystem:[PhysicsSystem class]];
	NSMutableArray *shapes = [NSMutableArray array];
    NSString *shapesFileName = [NSString stringWithFormat:@"%@-Shapes.plist", name];
	BodyInfo *bodyInfo = [physicsSystem createBodyInfoFromFile:shapesFileName bodyName:name];
	for (ChipmunkShape *shape in [bodyInfo shapes])
	{
		[shape setFriction:BACKGROUND_FRICTION];
		[shape setElasticity:BACKGROUND_ELASTICITY];
		[shape setLayers:BACKGROUND_LAYERS];
        [shape setGroup:[CollisionGroup LEVEL]];
	}
	[shapes addObjectsFromArray:[bodyInfo shapes]];
	PhysicsComponent *physicsComponent = [PhysicsComponent componentWithBody:[bodyInfo body] andShapes:shapes];
    [backgroundEntity addComponent:physicsComponent];
	
	// Sound
    SoundComponent *soundComponent = [SoundComponent component];
	[soundComponent setDefaultCollisionSoundName:@"BeeHitWall"];
	[backgroundEntity addComponent:soundComponent];
	
    [backgroundEntity refresh];
	
	[EntityUtil setEntityPosition:backgroundEntity position:CGPointMake(winSize.width / 2, winSize.height / 2)];
    
    return backgroundEntity;    
}

+(Entity *) createWater:(World *)world withLevelName:(NSString *)levelName
{
	NSString *theme = [[LevelOrganizer sharedOrganizer] themeForLevel:levelName];
	
//	if ([theme isEqualToString:@"A"])
//	{
//		return [self createEntity:@"WATER" world:world];
//	}
//	else if ([theme isEqualToString:@"B"])
//	{
//		return [self createEntity:@"LAVA" world:world];
//	}
//	else
//	{
//		return nil;
//	}
	
	Entity *waterEntity = [world createEntity];
	
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
	// Transform
	[waterEntity addComponent:[TransformComponent component]];
	
	// Render
	float r1, g1, b1;
	float r2, g2, b2;
	float diffusion;
	if ([theme isEqualToString:@"A"])
	{
		r1 = r2 = 24.0f / 255.0f;
		g1 = g2 = 98.0f / 255.0f;
		b1 = b2 = 185.0f / 255.0f;
		diffusion = 0.98f;
	}
	else if ([theme isEqualToString:@"B"])
	{
		r1 = 205.0f / 255.0f;
		g1 = 130.0f / 255.0f;
		b1 = 3.0f / 255.0f;
		r2 = 88.0 / 255.0f;
		g2 = 30.0f / 255.0f;
		b2 = 18.0f / 255.0f;
		diffusion = 0.96f;
	}
	CCSprite *sprite = [CCSprite node];
    CGRect bounds1 = CGRectMake(0.0f, 0.0f, winSize.width, 10.0f);
    Waves1DNode *wave1 = [[Waves1DNode alloc] initWithBounds:bounds1 count:48 damping:0.99f diffusion:diffusion];
	[wave1 setColor:ccc4f(r1, g1, b1, 0.5f)];
    [sprite addChild:wave1];
    CGRect bounds2 = CGRectMake(0.0f, 0.0f, winSize.width, 7.0f);
    Waves1DNode *wave2 = [[Waves1DNode alloc] initWithBounds:bounds2 count:48 damping:0.99f diffusion:diffusion];
	[wave2 setColor:ccc4f(r2, g2, b2, 0.7f)];
    [sprite addChild:wave2];
	RenderSprite *renderSprite = [RenderSprite renderSpriteWithSprite:sprite z:1];
	RenderComponent *renderComponent = [RenderComponent componentWithRenderSprite:renderSprite];
	[waterEntity addComponent:renderComponent];
	
	// Physics
	ChipmunkBody *body = [ChipmunkBody staticBody];
	NSMutableArray *shapes = [NSMutableArray array];
	int numEdgeVerts = 4;
    CGPoint edgeVerts[] = {
        cpv(0.0f, 0.0f),
        cpv(0.0f, 5.0f),
        cpv(winSize.width, 5.0f),
        cpv(winSize.width, 0.0f)
    };
    for (int i = 0; i < numEdgeVerts; i++)
    {
        int nextI = i == numEdgeVerts - 1 ? 0 : i + 1;
		ChipmunkShape *shape = [ChipmunkSegmentShape segmentWithBody:body from:edgeVerts[i] to:edgeVerts[nextI] radius:0];
		[shape setGroup:[CollisionGroup LEVEL]];
        [shapes addObject:shape];
    }
	PhysicsComponent *physicsComponent = [PhysicsComponent componentWithBody:body andShapes:shapes];
    [waterEntity addComponent:physicsComponent];
	
	// Water
	WaterComponent *waterComponent = [WaterComponent component];
	if ([theme isEqualToString:@"A"])
	{
		[waterComponent setSplashEntityType:@"WATER-SPLASH"];
	}
	else if ([theme isEqualToString:@"B"])
	{
		[waterComponent setSplashEntityType:@"LAVA-SPLASH"];
	}
	[waterEntity addComponent:waterComponent];
	
	[waterEntity refresh];
	
	return waterEntity;
}

+(Entity *) createEntity:(NSString *)type world:(World *)world edit:(BOOL)edit
{
	EntityDescription *entityDescription = [self getEntityDescription:type];
	
	if (entityDescription == nil)
	{
		return nil;
	}
	
	Entity *entity = [world createEntity];
	
	if (edit)
	{
		[entity addComponent:[EditComponent componentWithLevelLayoutType:type]];
	}
	
	NSArray *components = [entityDescription createComponents:world];
	for (Component *component in components)
	{
		[entity addComponent:component];
	}
	
	if (edit)
	{
		if ([entity hasComponent:[SpawnComponent class]] &&
			![entity hasComponent:[RenderComponent class]])
		{
			NSString *spawnType = [[SpawnComponent getFrom:entity] entityType];
			EntityDescription *spawnEntityDescription = [self getEntityDescription:spawnType];
			NSDictionary *renderComponentDict = [[spawnEntityDescription componentsDict] objectForKey:@"render"];
			if (renderComponentDict != nil)
			{
				RenderComponent *spawnRenderComponent = [RenderComponent componentWithContentsOfDictionary:renderComponentDict world:world];
				[entity addComponent:spawnRenderComponent];
			}
		}
	}
	
	GroupManager *groupManager = (GroupManager *)[world getManager:[GroupManager class]];
	for (NSString *groupName in [entityDescription groups])
	{
		[groupManager addEntity:entity toGroup:groupName];
	}
	
	LabelManager *labelManager = (LabelManager *)[world getManager:[LabelManager class]];
	for (NSString *labelName in [entityDescription labels])
	{
		[labelManager labelEntity:entity withLabel:labelName];
	}
	
	TagManager *tagManager = (TagManager *)[world getManager:[TagManager class]];
	for (NSString *tagName in [entityDescription tags])
	{
		[tagManager registerEntity:entity withTag:tagName];
	}
	
	[entity refresh];
	
	return entity;
}

+(EntityDescription *) getEntityDescription:(NSString *)type
{
	EntityDescription *entityDescription = [[EntityDescriptionCache sharedCache] entityDescriptionByType:type];
	if (entityDescription == nil)
	{
		entityDescription = [[EntityDescriptionLoader sharedLoader] loadEntityDescription:type];
		if (entityDescription != nil)
		{
			[[EntityDescriptionCache sharedCache] addEntityDescription:entityDescription];
		}
	}
	return entityDescription;
}

+(Entity *) createEntity:(NSString *)type world:(World *)world
{
	return [self createEntity:type world:world edit:FALSE];
}

+(Entity *) createBee:(World *)world withBeeType:(BeeType *)beeType andVelocity:(CGPoint)velocity
{
    Entity *beeEntity = [self createEntity:[beeType name] world:world];
	
	BeeComponent *beeComponent = [BeeComponent getFrom:beeEntity];
	[beeComponent resetBeeaterHitsLeft];
	
	PhysicsComponent *physicsComponent = [PhysicsComponent getFrom:beeEntity];
	[[physicsComponent body] setVel:velocity];
    
    return beeEntity;
}

+(Entity *) createAimPollen:(World *)world withBeeType:(BeeType *)beeType andVelocity:(CGPoint)velocity
{
    Entity *aimPollenEntity = [self createEntity:@"AIM-POLLEN" world:world];
	
	// Clone bee's physics component
	EntityDescription *beeEntityDescription = [self getEntityDescription:[beeType capitalizedString]];
	NSDictionary *beePhysicsDict = [[beeEntityDescription componentsDict] objectForKey:@"physics"];
	PhysicsComponent *physicsComponent = [PhysicsComponent componentWithContentsOfDictionary:beePhysicsDict world:world];
	[physicsComponent setLayers:AIM_POLLEN_LAYERS];
	[[physicsComponent body] setVel:velocity];
	[aimPollenEntity addComponent:physicsComponent];
	
	[aimPollenEntity refresh];
    
	RenderComponent *renderComponent = [RenderComponent getFrom:aimPollenEntity];
	RenderSprite *renderSprite = [[renderComponent renderSprites] objectAtIndex:0];
	[renderSprite playAnimationLoop:@"Pollen-Static"];
    CCFadeOut *fadeOutAction = [CCFadeOut actionWithDuration:0.8f];
    CCCallFunc *callFunctionAction = [CCCallFunc actionWithTarget:aimPollenEntity selector:@selector(deleteEntity)];
    [[renderSprite sprite] runAction:[CCSequence actions:fadeOutAction, callFunctionAction, nil]];
    
    return aimPollenEntity;
}

+(Entity *) createMovementIndicator:(World *)world forEntity:(Entity *)entity
{
	Entity *movementIndicatorEntity = [world createEntity];
	
    TransformComponent *transformComponent = [TransformComponent component];
    [movementIndicatorEntity addComponent:transformComponent];
	
	RenderComponent *originalRenderComponent = [RenderComponent getFrom:entity];
	RenderComponent *copiedRenderComponent = [originalRenderComponent copy];
	[copiedRenderComponent setAlpha:0.5f];
	[movementIndicatorEntity addComponent:copiedRenderComponent];
	[copiedRenderComponent release];
	
	EditComponent *editComponent = [EditComponent component];
	[movementIndicatorEntity addComponent:editComponent];
	
	[movementIndicatorEntity refresh];
	
	return movementIndicatorEntity;
}

+(Entity *) createSimpleAnimatedEntity:(World *)world
{
	return [self createSimpleAnimatedEntity:world animationFile:nil];
}

+(Entity *) createSimpleAnimatedEntity:(World *)world animationFile:(NSString *)animationFile
{
	Entity *entity = [world createEntity];
	
    TransformComponent *transformComponent = [TransformComponent component];
    [entity addComponent:transformComponent];
	
	RenderSystem *renderSystem = (RenderSystem *)[[world systemManager] getSystem:[RenderSystem class]];
	RenderSprite *renderSprite = [renderSystem createRenderSpriteWithSpriteSheetName:@"Shared" animationFile:animationFile z:3];
	RenderComponent *renderComponent = [RenderComponent componentWithRenderSprite:renderSprite];
	[entity addComponent:renderComponent];
	
	[entity refresh];
	
	return entity;
}

@end
