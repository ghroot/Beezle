
//  EntityFactory.m
//  Beezle
//
//  Created by Me on 13/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EntityFactory.h"
#import "BeeComponent.h"
#import "BodyInfo.h"
#import "CollisionGroup.h"
#import "EditComponent.h"
#import "EntityDescription.h"
#import "EntityDescriptionCache.h"
#import "EntityUtil.h"
#import "LevelOrganizer.h"
#import "PhysicsComponent.h"
#import "PhysicsSystem.h"
#import "RenderComponent.h"
#import "RenderSprite.h"
#import "RenderSystem.h"
#import "SoundComponent.h"
#import "SpawnComponent.h"
#import "TransformComponent.h"
#import "VoidComponent.h"
#import "WaterComponent.h"
#import "Waves1DNode.h"
#import "ZOrder.h"
#import "TeleportOutSprite.h"
#import "TeleportComponent.h"
#import "TeleportInSprite.h"
#import "ShardComponent.h"
#import "VolatileComponent.h"
#import "DisposableComponent.h"
#import "GroundComponent.h"

static const float BACKGROUND_FRICTION = 0.7f;
static const float BACKGROUND_ELASTICITY = 0.7f;
static const int BACKGROUND_LAYERS = 7;
static const float EDGE_FRICTION = 0.5f;
static const float EDGE_ELASTICITY = 0.0f;
static const int EDGE_LAYERS = 15;
static const float WATER_FRICTION = 0.9f;
static const float WATER_ELASTICITY = 0.1f;
static const int WATER_LAYERS = 5;
static const int AIM_POLLEN_LAYERS = 2;

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
	RenderComponent *renderComponent = [RenderComponent component];
	
	CCTexture2DPixelFormat currentFormat = [CCTexture2D defaultAlphaPixelFormat];
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
	NSString *backImageFileName = [NSString stringWithFormat:@"%@.jpg", name];
	RenderSprite *backRenderSprite = [RenderSprite renderSpriteWithFile:backImageFileName zOrder:[ZOrder Z_BACKGROUND_BACK]];
	[backRenderSprite setName:@"back"];
	[backRenderSprite markAsBackground];
	[renderComponent addRenderSprite:backRenderSprite];
	[CCTexture2D setDefaultAlphaPixelFormat:currentFormat];
	
	NSString *frontImageFileName = [NSString stringWithFormat:@"%@-front.png", name];
	CCSprite *frontImageSprite = [CCSprite spriteWithFile:frontImageFileName];
	if (frontImageSprite != nil)
	{
		RenderSprite *frontRenderSprite = [RenderSprite renderSpriteWithSprite:frontImageSprite zOrder:[ZOrder Z_BACKGROUND_FRONT]];
		[frontRenderSprite setName:@"front"];
		[renderComponent addRenderSprite:frontRenderSprite];
	}
	
    [backgroundEntity addComponent:renderComponent];
    
    // Physics
    PhysicsSystem *physicsSystem = (PhysicsSystem *)[[world systemManager] getSystem:[PhysicsSystem class]];
	NSMutableArray *shapes = [NSMutableArray array];
    NSString *shapesFileName = [NSString stringWithFormat:@"%@-Shapes.plist", name];
	BodyInfo *bodyInfo = [physicsSystem createBodyInfoFromFile:shapesFileName bodyName:name];
	if (bodyInfo != nil)
	{
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
	}
	
	// Sound
    SoundComponent *soundComponent = [SoundComponent component];
	[soundComponent setDefaultCollisionSoundName:@"BeeHitWall"];
	[backgroundEntity addComponent:soundComponent];

	// Ground
	GroundComponent *groundComponent = [GroundComponent component];
	[groundComponent setIsIce:[name hasPrefix:@"Level-C"]];
	[backgroundEntity addComponent:groundComponent];
	
    [backgroundEntity refresh];
	
	[EntityUtil setEntityPosition:backgroundEntity position:CGPointMake(winSize.width / 2, winSize.height / 2)];
    
    return backgroundEntity;    
}

+(Entity *) createWater:(World *)world withLevelName:(NSString *)levelName
{
	NSString *theme = [[LevelOrganizer sharedOrganizer] themeForLevel:levelName];
	
	Entity *waterEntity = [world createEntity];
	
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
	// Transform
	[waterEntity addComponent:[TransformComponent component]];
	
	// Render
	float r1, g1, b1, a1;
	float r2, g2, b2, a2;
	float damping, diffusion;
	if ([theme isEqualToString:@"A"] ||
			[theme isEqualToString:@"E"])
	{
		r1 = r2 = 24.0f / 255.0f;
		g1 = g2 = 98.0f / 255.0f;
		b1 = b2 = 185.0f / 255.0f;
		a1 = 0.5f;
		a2 = 0.7f;
		damping = 0.99f;
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
		a1 = 0.4f;
		a2 = 0.5f;
		damping = 0.99f;
		diffusion = 0.90f;
	}
    else
    {
        r1 = r2 = 0.0f;
        g1 = g2 = 0.0f;
        b1 = b2 = 0.0f;
        a1 = a2 = 0.0f;
        damping = 1.0f;
        diffusion = 1.0f;
    }
	CCSprite *sprite = [CCSprite node];
    CGRect bounds1 = CGRectMake(0.0f, 0.0f, winSize.width, 10.0f);
    Waves1DNode *wave1 = [[[Waves1DNode alloc] initWithBounds:bounds1 count:48 damping:damping diffusion:diffusion] autorelease];
	[wave1 setColor:ccc4f(r1, g1, b1, a1)];
    [sprite addChild:wave1];
    CGRect bounds2 = CGRectMake(0.0f, 0.0f, winSize.width, 7.0f);
    Waves1DNode *wave2 = [[[Waves1DNode alloc] initWithBounds:bounds2 count:48 damping:damping diffusion:diffusion] autorelease];
	[wave2 setColor:ccc4f(r2, g2, b2, a2)];
    [sprite addChild:wave2];
	RenderSprite *renderSprite = [RenderSprite renderSpriteWithSprite:sprite zOrder:[ZOrder Z_WATER]];
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
		[shape setFriction:WATER_FRICTION];
		[shape setElasticity:WATER_ELASTICITY];
		[shape setLayers:WATER_LAYERS];
		[shape setGroup:[CollisionGroup LEVEL]];
        [shapes addObject:shape];
    }
	PhysicsComponent *physicsComponent = [PhysicsComponent componentWithBody:body andShapes:shapes];
    [waterEntity addComponent:physicsComponent];
	
	// Water
	WaterComponent *waterComponent = [WaterComponent component];
	if ([theme isEqualToString:@"A"] ||
			[theme isEqualToString:@"E"])
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

+(Entity *) createEntity:(NSString *)type world:(World *)world instanceComponentsDict:(NSDictionary *)instanceComponentsDict edit:(BOOL)edit
{
	EntityDescription *entityDescription = [[EntityDescriptionCache sharedCache] entityDescriptionByType:type];

	if (entityDescription == nil)
	{
		NSLog(@"WARNING: Entity type not found: %@", type);
		return nil;
	}
	
	Entity *entity = [world createEntity];
	
	if (edit)
	{
		[entity addComponent:[EditComponent componentWithLevelLayoutType:type]];
	}
	
	NSArray *components = [entityDescription createComponents:world instanceComponentsDict:instanceComponentsDict];
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
			EntityDescription *spawnEntityDescription = [[EntityDescriptionCache sharedCache] entityDescriptionByType:spawnType];
			NSDictionary *renderTypeComponentDict = [[spawnEntityDescription typeComponentsDict] objectForKey:@"render"];
			if (renderTypeComponentDict != nil)
			{
				RenderComponent *spawnRenderComponent = [RenderComponent componentWithTypeComponentDict:renderTypeComponentDict andInstanceComponentDict:nil world:world];
				[entity addComponent:spawnRenderComponent];
			}
		}
		else if ([entity hasComponent:[TeleportComponent class]])
		{
			RenderSprite *renderSprite = [RenderSprite renderSpriteWithSprite:[TeleportInSprite node] zOrder:[ZOrder Z_FRONT]];
			RenderComponent *renderComponent = [RenderComponent componentWithRenderSprite:renderSprite];
			[entity addComponent:renderComponent];
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

+(Entity *) createEntity:(NSString *)type world:(World *)world edit:(BOOL)edit
{
	return [self createEntity:type world:world instanceComponentsDict:nil edit:edit];
}

+(Entity *) createEntity:(NSString *)type world:(World *)world
{
	return [self createEntity:type world:world instanceComponentsDict:nil edit:FALSE];
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

+(Entity *) createAimPollen:(World *)world withBeeType:(BeeType *)beeType velocity:(CGPoint)velocity duration:(float)duration
{
    Entity *aimPollenEntity = [self createEntity:@"AIM-POLLEN" world:world];
	
	// Clone bee's physics component
	EntityDescription *beeEntityDescription = [[EntityDescriptionCache sharedCache] entityDescriptionByType:[beeType name]];
	NSDictionary *beePhysicsDict = [[beeEntityDescription typeComponentsDict] objectForKey:@"physics"];
    PhysicsComponent *physicsComponent = [PhysicsComponent componentWithTypeComponentDict:beePhysicsDict andInstanceComponentDict:nil world:world];
	[physicsComponent setLayers:AIM_POLLEN_LAYERS];
	[[physicsComponent body] setVel:velocity];
	[aimPollenEntity addComponent:physicsComponent];
	
	[aimPollenEntity refresh];
    
	RenderComponent *renderComponent = [RenderComponent getFrom:aimPollenEntity];
	RenderSprite *renderSprite = [[renderComponent renderSprites] objectAtIndex:0];
	[renderSprite playAnimationLoop:@"Pollen-Yellow-Static"];
    CCFadeOut *fadeOutAction = [CCFadeOut actionWithDuration:duration];
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

+(Entity *) createTeleportOutPosition:(World *)world
{
	Entity *teleportOutPositionEntity = [world createEntity];

	TransformComponent *transformComponent = [TransformComponent component];
	[teleportOutPositionEntity addComponent:transformComponent];

	CCSprite *sprite = [TeleportOutSprite node];
	RenderSprite *renderSprite = [RenderSprite renderSpriteWithSprite:sprite zOrder:[ZOrder Z_FRONT]];
	RenderComponent *renderComponent = [RenderComponent componentWithRenderSprite:renderSprite];
	[teleportOutPositionEntity addComponent:renderComponent];

	EditComponent *editComponent = [EditComponent component];
	[teleportOutPositionEntity addComponent:editComponent];

	[teleportOutPositionEntity refresh];

	return teleportOutPositionEntity;
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
	RenderSprite *renderSprite = [renderSystem createRenderSpriteWithSpriteSheetName:@"Shared" animationFile:animationFile zOrder:[ZOrder Z_DEFAULT]];
	RenderComponent *renderComponent = [RenderComponent componentWithRenderSprite:renderSprite];
	[entity addComponent:renderComponent];
	
	[entity refresh];
	
	return entity;
}

+(Entity *) createShardPieceEntity:(World *)world animationName:(NSString *)animationName smallAnimationNames:(NSArray *)smallAnimationNames spriteSheetName:(NSString *)spriteSheetName animationFile:(NSString *)animationFile shapeSize:(CGSize)shapeSize
{
	Entity *entity = [world createEntity];

	// Transform
	TransformComponent *transformComponent = [TransformComponent component];
	[entity addComponent:transformComponent];

	// Render
	RenderSystem *renderSystem = (RenderSystem *)[[world systemManager] getSystem:[RenderSystem class]];
	RenderSprite *renderSprite = [renderSystem createRenderSpriteWithSpriteSheetName:spriteSheetName animationFile:animationFile zOrder:[ZOrder Z_DEFAULT]];
	[renderSprite playAnimationLoop:animationName];
	RenderComponent *renderComponent = [RenderComponent componentWithRenderSprite:renderSprite];
	[entity addComponent:renderComponent];

	// Physics
	ChipmunkBody *body = [ChipmunkBody bodyWithMass:1.0f andMoment:1.0f];
	float force = [body mass] * GRAVITY;
	[body applyForce:CGPointMake(0.0f, force) offset:CGPointZero];
	NSMutableArray *shapes = [NSMutableArray array];
	int numVerts = 4;
	CGPoint verts[] = {
		cpv(-shapeSize.width / 2, -shapeSize.height / 2),
		cpv(-shapeSize.width / 2, shapeSize.height / 2),
		cpv(shapeSize.width / 2, shapeSize.height / 2),
		cpv(shapeSize.width / 2, -shapeSize.height / 2)
	};
	for (int i = 0; i < numVerts; i++)
	{
		ChipmunkShape *shape = [ChipmunkPolyShape polyWithBody:body count:numVerts verts:verts offset:CGPointZero];
		[shape setFriction:0.6];
		[shape setElasticity:0.5f];
		[shape setLayers:2];
		[shape setGroup:[CollisionGroup OBJECT]];
		[shapes addObject:shape];
	}
	PhysicsComponent *physicsComponent = [PhysicsComponent componentWithBody:body andShapes:shapes];
	[entity addComponent:physicsComponent];

	if (smallAnimationNames != nil &&
			[smallAnimationNames count] > 0)
	{
		// Disposable
		DisposableComponent *disposableComponent = [DisposableComponent component];
		[disposableComponent setDeleteEntityWhenDisposed:TRUE];
		[entity addComponent:disposableComponent];

		// Shard
		ShardComponent *shardComponent = [ShardComponent component];
		[shardComponent setPiecesSpriteSheetName:spriteSheetName];
		[shardComponent setPiecesAnimationFileName:animationFile];
		NSMutableArray *smallPiecesAnimations = [NSMutableArray array];
		for (NSString *smallAnimationName in smallAnimationNames)
		{
			NSMutableDictionary *smallPieceAnimation = [NSMutableDictionary dictionary];
			[smallPieceAnimation setObject:smallAnimationName forKey:@"pieceAnimation"];
			[smallPiecesAnimations addObject:smallPieceAnimation];
		}
		[shardComponent setPiecesAnimations:smallPiecesAnimations];
		[shardComponent setPiecesSpawnType:SHARD_PIECES_SPAWN_FADEOUT];
		[entity addComponent:shardComponent];

		// Volatile
		VolatileComponent *volatileComponent = [VolatileComponent component];
		[entity addComponent:volatileComponent];
	}

	[entity refresh];

	return entity;
}

+(Entity *) createShardPieceEntity:(World *)world animationName:(NSString *)animationName smallAnimationNames:(NSArray *)smallAnimationNames spriteSheetName:(NSString *)spriteSheetName animationFile:(NSString *)animationFile
{
	return [self createShardPieceEntity:world animationName:animationName smallAnimationNames:smallAnimationNames spriteSheetName:spriteSheetName animationFile:animationFile shapeSize:CGSizeMake(20.0f, 12.0f)];
}

@end
