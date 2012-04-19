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
#import "Utils.h"

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
			NSString *spriteSheetName = [spriteDict objectForKey:@"spriteSheetName"];
			NSString *textureFile = [spriteDict objectForKey:@"textureFile"];
			NSString *animationFile = [spriteDict objectForKey:@"animationFile"];
			int z = [[spriteDict objectForKey:@"z"] intValue];
			NSArray *defaultIdleAnimationNames = nil;
			if ([spriteDict objectForKey:@"defaultIdleAnimations"] != nil)
			{
				defaultIdleAnimationNames = [spriteDict objectForKey:@"defaultIdleAnimations"];
			}
			else if ([spriteDict objectForKey:@"defaultIdleAnimation"] != nil)
			{
				defaultIdleAnimationNames = [NSArray arrayWithObject:[spriteDict objectForKey:@"defaultIdleAnimation"]];
			}
			NSArray *defaultDestroyAnimationNames = nil;
			if ([spriteDict objectForKey:@"defaultDestroyAnimations"] != nil)
			{
				defaultDestroyAnimationNames = [spriteDict objectForKey:@"defaultDestroyAnimations"];
			}
			else if ([spriteDict objectForKey:@"defaultDestroyAnimation"] != nil)
			{
				defaultDestroyAnimationNames = [NSArray arrayWithObject:[spriteDict objectForKey:@"defaultDestroyAnimation"]];
			}
            
			RenderSprite *renderSprite = nil;
			if (spriteSheetName != nil)
			{
				renderSprite = [renderSystem createRenderSpriteWithSpriteSheetName:spriteSheetName animationFile:animationFile z:z];
				[renderSprite setDefaultIdleAnimationNames:defaultIdleAnimationNames];
				[renderSprite setDefaultDestroyAnimationNames:defaultDestroyAnimationNames];
			}
			else if (textureFile != nil)
			{
				renderSprite = [renderSystem createRenderSpriteWithFile:[CCFileUtils fullPathFromRelativePath:textureFile] z:z];
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
			
            [renderSprite playDefaultIdleAnimation];
		}
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

-(RenderSprite *) getRenderSprite:(NSString *)name
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

-(RenderSprite *) firstRenderSprite
{
	return [_renderSprites objectAtIndex:0];
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

-(void) playAnimation:(NSString *)animationName withLoops:(int)nLoops
{
    for (RenderSprite *renderSprite in _renderSprites)
    {
        [renderSprite playAnimation:animationName withLoops:nLoops];
    }
}

-(void) playAnimation:(NSString *)animationName
{
    for (RenderSprite *renderSprite in _renderSprites)
    {
        [renderSprite playAnimation:animationName];
    }
}

-(void) playAnimation:(NSString *)animationName withCallbackTarget:(id)target andCallbackSelector:(SEL)selector
{
    for (RenderSprite *renderSprite in _renderSprites)
    {
        if (renderSprite == [_renderSprites objectAtIndex:0])
        {
            // Callback invokation should only be done once, we use the first render sprite for that
            [renderSprite playAnimation:animationName withCallbackTarget:target andCallbackSelector:selector];
        }
        else
        {
            [renderSprite playAnimation:animationName withLoops:1];
        }
    }
}

-(void) playDefaultDestroyAnimationWithCallbackTarget:(id)target andCallbackSelector:(SEL)selector
{
    for (RenderSprite *renderSprite in _renderSprites)
    {
        if (renderSprite == [_renderSprites objectAtIndex:0])
        {
            // Callback invokation should only be done once, we use the first render sprite for that
            [renderSprite playAnimation:[renderSprite randomDefaultDestroyAnimationName] withCallbackTarget:target andCallbackSelector:selector];
        }
        else
        {
            [renderSprite playDefaultDestroyAnimation];
        }
    }
}

-(void) playAnimationsLoopLast:(NSArray *)animationNames
{
    for (RenderSprite *renderSprite in _renderSprites)
    {
        [renderSprite playAnimationsLoopLast:animationNames];
    }
}

-(void) playAnimationsLoopAll:(NSArray *)animationNames
{
    for (RenderSprite *renderSprite in _renderSprites)
    {
        [renderSprite playAnimationsLoopAll:animationNames];
    }
}

-(BOOL) hasDefaultIdleAnimation
{
	for (RenderSprite *renderSprite in _renderSprites)
    {
        if ([[renderSprite defaultIdleAnimationNames] count] > 0)
		{
			return TRUE;
		}
    }
	return FALSE;
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
        if ([[renderSprite defaultDestroyAnimationNames] count] > 0)
		{
			return TRUE;
		}
    }
	return FALSE;
}

-(void) playDefaultDestroyAnimation
{
    for (RenderSprite *renderSprite in _renderSprites)
    {
        [renderSprite playDefaultDestroyAnimation];
    }
}

@end
