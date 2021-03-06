//
//  RenderSystem.m
//  Beezle
//
//  Created by Me on 08/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RenderSystem.h"
#import "RenderComponent.h"
#import "RenderSprite.h"
#import "TransformComponent.h"
#import "ZOrder.h"
#import "MemoryManager.h"
#import "RenderSpriteRotationType.h"
#import "PhysicsComponent.h"
#import "Utils.h"

static const int BATCH_NODE_CAPACITY = 140;

@implementation RenderSystem

@synthesize layer = _layer;
@synthesize spriteSheetsByName = _spriteSheetsByName;
@synthesize disableSpriteSheetUnloading = _disableSpriteSheetUnloading;

-(id) initWithLayer:(CCLayer *)layer
{
    if (self = [super initWithUsedComponentClasses:[NSArray arrayWithObjects:[TransformComponent class], [RenderComponent class], nil]])
    {
        _layer = layer;
        _spriteSheetsByName = [NSMutableDictionary new];
		_loadedAnimationsFileNames = [NSMutableSet new];
    }
    return self;
}

-(void) dealloc
{
	[_transformComponentMapper release];
	[_renderComponentMapper release];
	[_physicsComponentMapper release];

    [_spriteSheetsByName release];
	[_loadedAnimationsFileNames release];

	[super dealloc];
}

-(RenderSprite *) createRenderSpriteWithSpriteSheetName:(NSString *)name zOrder:(ZOrder *)zOrder
{
    return [self createRenderSpriteWithSpriteSheetName:name animationFile:nil zOrder:zOrder];
}

-(RenderSprite *) createRenderSpriteWithSpriteSheetName:(NSString *)name animationFile:(NSString *)animationsFileName zOrder:(ZOrder *)zOrder;
{
    CCSpriteBatchNode *spriteSheet = (CCSpriteBatchNode *)[_spriteSheetsByName objectForKey:name];
    if (spriteSheet == nil)
    {
        // Create sprite batch node
        NSString *spriteSheetFileName = [NSString stringWithFormat:@"%@.plist", name];
        NSString *spriteSheetFilePath = [[CCFileUtils sharedFileUtils] fullPathFromRelativePath:spriteSheetFileName];
        NSDictionary *spriteSheetDict = [NSDictionary dictionaryWithContentsOfFile:spriteSheetFilePath];
        NSDictionary *metadataDict = [spriteSheetDict objectForKey:@"metadata"];
        NSString *texturePath = [metadataDict objectForKey:@"textureFileName"];
        
        ZOrder *spriteSheetZOrder;
        if ([name isEqualToString:@"Shared"])
        {
            spriteSheetZOrder = [ZOrder Z_SHEET_SHARED];
        }
		else if ([name isEqualToString:@"A"])
        {
            spriteSheetZOrder = [ZOrder Z_SHEET_A];
			if (!_disableSpriteSheetUnloading)
			{
				[[MemoryManager sharedManager] ensureThemeSpriteSheetIsUniquelyLoaded:name];
			}
        }
		else if ([name isEqualToString:@"B"])
        {
            spriteSheetZOrder = [ZOrder Z_SHEET_B];
			if (!_disableSpriteSheetUnloading)
			{
				[[MemoryManager sharedManager] ensureThemeSpriteSheetIsUniquelyLoaded:name];
			}
        }
		else if ([name isEqualToString:@"C"])
        {
            spriteSheetZOrder = [ZOrder Z_SHEET_C];
			if (!_disableSpriteSheetUnloading)
			{
				[[MemoryManager sharedManager] ensureThemeSpriteSheetIsUniquelyLoaded:name];
			}
        }
        else if ([name isEqualToString:@"D"])
        {
            spriteSheetZOrder = [ZOrder Z_SHEET_D];
			if (!_disableSpriteSheetUnloading)
			{
				[[MemoryManager sharedManager] ensureThemeSpriteSheetIsUniquelyLoaded:name];
			}
        }
        else if ([name isEqualToString:@"Boss-A"] ||
				[name isEqualToString:@"Boss-B"] ||
				[name isEqualToString:@"Boss-C"] ||
				[name isEqualToString:@"Boss-D"])
        {
            spriteSheetZOrder = [ZOrder Z_SHEET_BOSS];
			if (!_disableSpriteSheetUnloading)
			{
				[[MemoryManager sharedManager] ensureThemeBossSpriteSheetIsUniquelyLoaded:name];
			}
        }
        else
        {
            spriteSheetZOrder = [ZOrder Z_SHEET_DEFAULT];
        }

		spriteSheet = [CCSpriteBatchNode batchNodeWithFile:texturePath capacity:BATCH_NODE_CAPACITY];
        [_layer addChild:spriteSheet z:[spriteSheetZOrder z]];
        [_spriteSheetsByName setObject:spriteSheet forKey:name];
        
		// Create frames from file
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:spriteSheetFileName];
    }

	if (animationsFileName != nil &&
		![_loadedAnimationsFileNames containsObject:animationsFileName])
	{
		// Add animations if not already loaded
		[[CCAnimationCache sharedAnimationCache] addAnimationsWithFile:animationsFileName];
        [_loadedAnimationsFileNames addObject:animationsFileName];
	}
    
	return [RenderSprite renderSpriteWithSpriteSheet:spriteSheet zOrder:zOrder];
}

-(void) initialise
{
	_transformComponentMapper = [[ComponentMapper alloc] initWithEntityManager:[_world entityManager] componentClass:[TransformComponent class]];
	_renderComponentMapper = [[ComponentMapper alloc] initWithEntityManager:[_world entityManager] componentClass:[RenderComponent class]];
	_physicsComponentMapper = [[ComponentMapper alloc] initWithEntityManager:[_world entityManager] componentClass:[PhysicsComponent class]];
}

-(void) entityAdded:(Entity *)entity
{
    RenderComponent *renderComponent = [_renderComponentMapper getComponentFor:entity];
	for (RenderSprite *renderSprite in [renderComponent renderSprites])
	{
		if ([renderSprite spriteSheet] != nil)
		{
			[renderSprite addSpriteToSpriteSheet];
		}
		else if ([renderSprite sprite] != nil)
		{
			[_layer addChild:[renderSprite sprite] z:[[renderSprite zOrder] z]];
		}
	}
}

-(void) entityRemoved:(Entity *)entity
{
	RenderComponent *renderComponent = [_renderComponentMapper getComponentFor:entity];
	for (RenderSprite *renderSprite in [renderComponent renderSprites])
	{
		if ([renderSprite spriteSheet] != nil)
		{
			[renderSprite removeSpriteFromSpriteSheet];
		}
		else if ([renderSprite sprite] != nil)
		{
			[_layer removeChild:[renderSprite sprite] cleanup:TRUE];
		}
	}
}

-(void) processEntity:(Entity *)entity
{
    TransformComponent *transformComponent = [_transformComponentMapper getComponentFor:entity];
	RenderComponent *renderComponent = [_renderComponentMapper getComponentFor:entity];
    for (RenderSprite *renderSprite in [renderComponent renderSprites])
	{
		CGPoint newPosition;
		newPosition.x = [transformComponent position].x + [renderSprite offset].x;
		newPosition.y = [transformComponent position].y + [renderSprite offset].y;
		[[renderSprite sprite] setPosition:newPosition];
		if ([renderSprite rotationType] == ROTATION_TYPE_NORMAL)
		{
			[[renderSprite sprite] setRotation:[transformComponent rotation]];
		}
		else if ([renderSprite rotationType] == ROTATION_TYPE_VELOCITY)
		{
			if ([_physicsComponentMapper hasEntityComponent:entity])
			{
				PhysicsComponent *physicsComponent = [_physicsComponentMapper getComponentFor:entity];
				cpVect velocity = [[physicsComponent body] vel];
				float angle = ccpToAngle(velocity);
				[[renderSprite sprite] setRotation:[Utils chipmunkRadiansToCocos2dDegrees:angle] + 90.0f];
			}
		}
        [[renderSprite sprite] setScaleX:([transformComponent scale].x * [renderSprite scale].x)];
        [[renderSprite sprite] setScaleY:([transformComponent scale].y * [renderSprite scale].y)];
	}
}

@end
