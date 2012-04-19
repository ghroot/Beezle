//
//  RenderableBehaviour.m
//  Beezle
//
//  Created by Me on 06/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RenderComponent.h"
#import "RenderSprite.h"
#import "RenderSystem.h"
#import "StringList.h"
#import "Utils.h"

@interface RenderComponent()

-(void) playAnimationOnce:(NSString *)animationName andCallBlockAtEnd:(void(^)())block;
-(void) playAnimationOnce:(NSString *)animationName;

@end

@implementation RenderComponent

@synthesize renderSprites = _renderSprites;
@synthesize renderSpriteOffsets = _renderSpriteOffsets;

+(RenderComponent *) componentWithRenderSprite:(RenderSprite *)renderSprite
{
	RenderComponent *renderComponent = [[[RenderComponent alloc] init] autorelease];
	[renderComponent addRenderSprite:renderSprite];
	return renderComponent;
}

// Designated initializer
-(id) init
{
	if (self = [super init])
	{
		_name = @"render";
		_renderSprites = [NSMutableArray new];
        _renderSpriteOffsets = [NSMutableDictionary new];
	}
	return self;
}

-(id) initWithContentsOfDictionary:(NSDictionary *)dict world:(World *)world
{
	if (self = [self init])
	{
		RenderSystem *renderSystem = (RenderSystem *)[[world systemManager] getSystem:[RenderSystem class]];
		for (NSDictionary *spriteDict in [dict objectForKey:@"sprites"])
		{
			RenderSprite *renderSprite = nil;
			int z = [[spriteDict objectForKey:@"z"] intValue];
			if ([spriteDict objectForKey:@"spriteSheetName"] != nil)
			{
				renderSprite = [renderSystem createRenderSpriteWithSpriteSheetName:[spriteDict objectForKey:@"spriteSheetName"] animationFile:[spriteDict objectForKey:@"animationFile"] z:z];
				[[renderSprite defaultIdleAnimationNames] addStringsFromDictionary:spriteDict baseName:@"defaultIdleAnimation"];
				[[renderSprite defaultDestroyAnimationNames] addStringsFromDictionary:spriteDict baseName:@"defaultDestroyAnimation"];
			}
			else if ([spriteDict objectForKey:@"textureFile"] != nil)
			{
				renderSprite = [renderSystem createRenderSpriteWithFile:[CCFileUtils fullPathFromRelativePath:[spriteDict objectForKey:@"textureFile"]] z:z];
			}
            
            if ([spriteDict objectForKey:@"name"] != nil)
            {
                [renderSprite setName:[spriteDict objectForKey:@"name"]];
            }
            
            CGPoint offset = CGPointZero;
            if ([spriteDict objectForKey:@"offset"] != nil)
            {
                offset = [Utils stringToPoint:[spriteDict objectForKey:@"offset"]];
            }
            
            if ([spriteDict objectForKey:@"anchorPoint"] != nil)
            {
                CGPoint anchorPoint = [Utils stringToPoint:[spriteDict objectForKey:@"anchorPoint"]];
                [[renderSprite sprite] setAnchorPoint:anchorPoint];
            }
            
            if ([spriteDict objectForKey:@"scale"] != nil)
            {
                CGPoint scale = [Utils stringToPoint:[spriteDict objectForKey:@"scale"]];
                [[renderSprite sprite] setScaleX:scale.x];
                [[renderSprite sprite] setScaleY:scale.y];
            }
            
			[self addRenderSprite:renderSprite atOffset:offset];
		}
		[self playDefaultIdleAnimation];
	}
	return self;
}

-(void) dealloc
{
	[_renderSprites release];
    [_renderSpriteOffsets release];
    
    [super dealloc];
}

-(id) copyWithZone:(NSZone *)zone
{
	RenderComponent *copiedRenderComponent = [super copyWithZone:zone];
	for (RenderSprite *renderSprite in _renderSprites)
	{
		RenderSprite *copiedRenderSprite = [renderSprite copy];
		[copiedRenderComponent addRenderSprite:copiedRenderSprite];
		[copiedRenderSprite release];
	}
    NSDictionary *copiedRenderSpriteOffsets = [_renderSpriteOffsets copy];
    [copiedRenderComponent setRenderSpriteOffsets:copiedRenderSpriteOffsets];
	return copiedRenderComponent;
}

-(void) addRenderSprite:(RenderSprite *)renderSprite atOffset:(CGPoint)offset
{
	[_renderSprites addObject:renderSprite];
    [_renderSpriteOffsets setObject:[NSValue valueWithCGPoint:offset] forKey:renderSprite];
}

-(void) addRenderSprite:(RenderSprite *)renderSprite
{
    [self addRenderSprite:renderSprite atOffset:CGPointZero];
}

-(RenderSprite *) renderSpriteWithName:(NSString *)name
{
    for (RenderSprite *renderSprite in _renderSprites)
    {
        if ([[renderSprite name] isEqualToString:name])
        {
            return renderSprite;
        }
    }
    return nil;
}

-(RenderSprite *) defaultRenderSprite
{
	return [self renderSpriteWithName:@"default"];
}

-(CGPoint) getOffsetForRenderSprite:(RenderSprite *)renderSprite
{
    return [[_renderSpriteOffsets objectForKey:renderSprite] CGPointValue];
}

-(void) setAlpha:(float)alpha
{
	for (RenderSprite *renderSprite in _renderSprites)
	{
		[[renderSprite sprite] setOpacity:(alpha * 256)];
	}
}

-(void) playAnimationOnce:(NSString *)animationName andCallBlockAtEnd:(void(^)())block
{
	for (RenderSprite *renderSprite in _renderSprites)
	{
		if (renderSprite == [_renderSprites lastObject])
		{
			[renderSprite playAnimationOnce:animationName andCallBlockAtEnd:block];
		}
		else
		{
			[renderSprite playAnimationOnce:animationName];
		}
	}
}

-(void) playAnimationOnce:(NSString *)animationName
{
	for (RenderSprite *renderSprite in _renderSprites)
	{
		[renderSprite playAnimationOnce:animationName];
	}
}

-(BOOL) hasDefaultIdleAnimation
{
	for (RenderSprite *renderSprite in _renderSprites)
	{
		if (![renderSprite hasDefaultIdleAnimation])
		{
			return FALSE;
		}
	}
	return TRUE;
}

-(void) playDefaultIdleAnimation
{
	for (RenderSprite *renderSprite in _renderSprites)
	{
		[renderSprite playDefaultIdleAnimation];
	}
}

-(BOOL) hasDefaultDestroyAnimation
{
	for (RenderSprite *renderSprite in _renderSprites)
	{
		if (![renderSprite hasDefaultDestroyAnimation])
		{
			return FALSE;
		}
	}
	return TRUE;
}

-(void) playDefaultDestroyAnimationAndCallBlockAtEnd:(void(^)())block
{
	for (RenderSprite *renderSprite in _renderSprites)
	{
		if (renderSprite == [_renderSprites lastObject])
		{
			[renderSprite playDefaultDestroyAnimationAndCallBlockAtEnd:block];
		}
		else
		{
			[renderSprite playDefaultDestroyAnimation];
		}
	}
}

-(void) playDefaultDestroyAnimation
{
	for (RenderSprite *renderSprite in _renderSprites)
	{
		[renderSprite playDefaultDestroyAnimation];
	}
}

@end
