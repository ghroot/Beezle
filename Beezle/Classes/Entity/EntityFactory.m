
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
#import "CollisionType.h"
#import "EditComponent.h"
#import "EntityDescription.h"
#import "EntityDescriptionCache.h"
#import "EntityDescriptionLoader.h"
#import "LevelLayoutEntry.h"
#import "PhysicsComponent.h"
#import "PhysicsSystem.h"
#import "RenderComponent.h"
#import "RenderSprite.h"
#import "RenderSystem.h"
#import "TransformComponent.h"

#define BACKGROUND_FRICTION 0.7f
#define BACKGROUND_ELASTICITY 0.7f
#define BACKGROUND_LAYERS 7
#define EDGE_LAYERS 7

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
    RenderSprite *renderSprite = [renderSystem createRenderSpriteWithFile:imageFileName z:1];
    [renderSprite markAsBackground];
	RenderComponent *renderComponent = [RenderComponent componentWithRenderSprite:renderSprite];
    [backgroundEntity addComponent:renderComponent];
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
    
    // Physics
    PhysicsSystem *physicsSystem = (PhysicsSystem *)[[world systemManager] getSystem:[PhysicsSystem class]];
    NSString *shapesFileName = [NSString stringWithFormat:@"%@-Shapes.plist", name];
	BodyInfo *bodyInfo = [physicsSystem createBodyInfoFromFile:shapesFileName bodyName:name collisionType:[CollisionType BACKGROUND]];
	for (ChipmunkShape *shape in [bodyInfo shapes])
	{
		[shape setFriction:BACKGROUND_FRICTION];
		[shape setElasticity:BACKGROUND_ELASTICITY];
		[shape setLayers:BACKGROUND_LAYERS];
	}
	PhysicsComponent *physicsComponent = [PhysicsComponent componentWithBody:[bodyInfo body] andShapes:[bodyInfo shapes]];
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
        [shape setLayers:EDGE_LAYERS];
        [shapes addObject:shape];
    }
    PhysicsComponent *physicsComponent = [PhysicsComponent componentWithBody:body andShapes:shapes];
    [edgeEntity addComponent:physicsComponent];
    
    [edgeEntity refresh];
    
    return edgeEntity;
}

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

+(Entity *) createBee:(World *)world withBeeType:(BeeType *)beeType andVelocity:(CGPoint)velocity
{
    Entity *beeEntity = [self createEntity:[beeType name] world:world];
	
	PhysicsComponent *physicsComponent = [PhysicsComponent getFrom:beeEntity];
	[[physicsComponent body] setVel:velocity];
    
    return beeEntity;
}

+(Entity *) createAimPollen:(World *)world withVelocity:(CGPoint)velocity
{
    Entity *aimPollenEntity = [self createEntity:@"AIM-POLLEN" world:world];
	
	PhysicsComponent *physicsComponent = [PhysicsComponent getFrom:aimPollenEntity];
	[[physicsComponent body] setVel:velocity];
    
	RenderComponent *renderComponent = [RenderComponent getFrom:aimPollenEntity];
	RenderSprite *renderSprite = [[renderComponent renderSprites] objectAtIndex:0];
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
	Entity *entity = [world createEntity];
	
    TransformComponent *transformComponent = [TransformComponent component];
    [entity addComponent:transformComponent];
	
	RenderSystem *renderSystem = (RenderSystem *)[[world systemManager] getSystem:[RenderSystem class]];
	RenderSprite *renderSprite = [renderSystem createRenderSpriteWithSpriteSheetName:@"Sprites" z:3];
	RenderComponent *renderComponent = [RenderComponent componentWithRenderSprite:renderSprite];
	[entity addComponent:renderComponent];
	
	[entity refresh];
	
	return entity;
}

@end
