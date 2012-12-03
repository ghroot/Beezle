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

static const int BATCH_NODE_CAPACITY = 140;

@implementation RenderSystem

@synthesize layer = _layer;

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
			[[MemoryManager sharedManager] ensureThemeSpriteSheetIsUniquelyLoaded:name];
        }
		else if ([name isEqualToString:@"B"])
        {
            spriteSheetZOrder = [ZOrder Z_SHEET_B];
			[[MemoryManager sharedManager] ensureThemeSpriteSheetIsUniquelyLoaded:name];
        }
		else if ([name isEqualToString:@"C"])
        {
            spriteSheetZOrder = [ZOrder Z_SHEET_C];
			[[MemoryManager sharedManager] ensureThemeSpriteSheetIsUniquelyLoaded:name];
        }
        else if ([name isEqualToString:@"D"])
        {
            spriteSheetZOrder = [ZOrder Z_SHEET_D];
			[[MemoryManager sharedManager] ensureThemeSpriteSheetIsUniquelyLoaded:name];
        }
        else if ([name isEqualToString:@"Boss-A"] ||
				[name isEqualToString:@"Boss-B"] ||
				[name isEqualToString:@"Boss-C"] ||
				[name isEqualToString:@"Boss-D"])
        {
            spriteSheetZOrder = [ZOrder Z_SHEET_BOSS];
			[[MemoryManager sharedManager] ensureThemeBossSpriteSheetIsUniquelyLoaded:name];
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
		[[renderSprite sprite] setRotation:[transformComponent rotation]];
        [[renderSprite sprite] setScaleX:([transformComponent scale].x * [renderSprite scale].x)];
        [[renderSprite sprite] setScaleY:([transformComponent scale].y * [renderSprite scale].y)];
	}
}

@end
