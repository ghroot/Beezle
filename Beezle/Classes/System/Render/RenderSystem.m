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

@implementation RenderSystem

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
    [_spriteSheetsByName release];
	[_loadedAnimationsFileNames release];
    
    [super dealloc];
}

-(RenderSprite *) createRenderSpriteWithFile:(NSString *)fileName z:(int)z
{
    CCSpriteBatchNode *spriteSheet = (CCSpriteBatchNode *)[_spriteSheetsByName objectForKey:fileName];
    if (spriteSheet == nil)
    {
        spriteSheet = [CCSpriteBatchNode batchNodeWithFile:fileName];
        [_layer addChild:spriteSheet z:z];
        [_spriteSheetsByName setObject:spriteSheet forKey:fileName];
		
		// No frames, uses whole texture
    }
	return [RenderSprite renderSpriteWithSpriteSheet:spriteSheet z:z];
}

-(RenderSprite *) createRenderSpriteWithSpriteSheetName:(NSString *)name z:(int)z
{
    return [self createRenderSpriteWithSpriteSheetName:name animationFile:nil z:z];
}

-(RenderSprite *) createRenderSpriteWithSpriteSheetName:(NSString *)name animationFile:(NSString *)animationsFileName z:(int)z;
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
        spriteSheet = [CCSpriteBatchNode batchNodeWithFile:texturePath];
        [_layer addChild:spriteSheet z:z];
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
    
	return [RenderSprite renderSpriteWithSpriteSheet:spriteSheet z:z];
}

-(void) entityAdded:(Entity *)entity
{
    RenderComponent *renderComponent = [RenderComponent getFrom:entity];
	for (RenderSprite *renderSprite in [renderComponent renderSprites])
	{
		if ([renderSprite spriteSheet] != nil)
		{
			[renderSprite addSpriteToSpriteSheet];
		}
		else if ([renderSprite sprite] != nil)
		{
			[_layer addChild:[renderSprite sprite] z:[renderSprite z]];
		}
	}
    
    [super entityAdded:entity];
}

-(void) entityRemoved:(Entity *)entity
{
    RenderComponent *renderComponent = [RenderComponent getFrom:entity];
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
    
    [super entityRemoved:entity];
}

-(void) processEntity:(Entity *)entity
{
    TransformComponent *transformComponent = [TransformComponent getFrom:entity];
    RenderComponent *renderComponent = [RenderComponent getFrom:entity];
	
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
