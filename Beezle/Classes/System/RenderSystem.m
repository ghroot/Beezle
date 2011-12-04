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
        _spriteSheetsByName = [[NSMutableDictionary alloc] init];
        _loadedAnimationFileNames = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void) dealloc
{
    [_spriteSheetsByName release];
    [_loadedAnimationFileNames release];
    
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
	return [RenderSprite renderSpriteWithSpriteSheet:spriteSheet];
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
        NSString *dataFileName = [NSString stringWithFormat:@"%@.plist", name];
        NSString *dataPath = [CCFileUtils fullPathFromRelativePath:dataFileName];
        NSDictionary *dataDict = [NSDictionary dictionaryWithContentsOfFile:dataPath];
        NSDictionary *metadataDict = [dataDict objectForKey:@"metadata"];
        NSString *texturePath = [metadataDict objectForKey:@"textureFileName"];
        spriteSheet = [CCSpriteBatchNode batchNodeWithFile:texturePath];
        [_layer addChild:spriteSheet z:z];
        [_spriteSheetsByName setObject:spriteSheet forKey:name];
        
		// Create frames from file
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[NSString stringWithFormat:@"%@.plist", name]];
    }
    
    if (animationsFileName != nil &&
        ![_loadedAnimationFileNames containsObject:animationsFileName])
    {
        // Create animations from file
        [[CCAnimationCache sharedAnimationCache] addAnimationsWithFile:animationsFileName];
        
        [_loadedAnimationFileNames addObject:animationsFileName];
    }
    
	return [RenderSprite renderSpriteWithSpriteSheet:spriteSheet];
}

-(void) entityAdded:(Entity *)entity
{
    RenderComponent *renderComponent = (RenderComponent *)[entity getComponent:[RenderComponent class]];
	for (RenderSprite *renderSprite in [renderComponent renderSprites])
	{
		[[renderSprite spriteSheet] addChild:[renderSprite sprite]];
	}
    
    [super entityAdded:entity];
}

-(void) entityRemoved:(Entity *)entity
{
    RenderComponent *renderComponent = (RenderComponent *)[entity getComponent:[RenderComponent class]];
	for (RenderSprite *renderSprite in [renderComponent renderSprites])
	{
		[[renderSprite spriteSheet] removeChild:[renderSprite sprite] cleanup:TRUE];
	}
    
    [super entityRemoved:entity];
}

-(void) processEntity:(Entity *)entity
{
    TransformComponent *transformComponent = (TransformComponent *)[entity getComponent:[TransformComponent class]];
    RenderComponent *renderComponent = (RenderComponent *)[entity getComponent:[RenderComponent class]];
	
    for (RenderSprite *renderSprite in [renderComponent renderSprites])
	{
		[[renderSprite sprite] setPosition:[transformComponent position]];
		[[renderSprite sprite] setRotation:[transformComponent rotation]];
		[[renderSprite sprite] setScaleX:[transformComponent scale].x];
		[[renderSprite sprite] setScaleY:[transformComponent scale].y];
	}
}

@end
