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

+(RenderComponent *) componentWithRenderSprite:(RenderSprite *)renderSprite
{
	RenderComponent *renderComponent = [[[RenderComponent alloc] init] autorelease];
	[renderComponent addRenderSprite:renderSprite withName:@"default"];
	return renderComponent;
}

// Designated initializer
-(id) init
{
	if (self = [super init])
	{
		_name = @"render";
		_renderSprites = [NSMutableArray new];
		_renderSpritesByName = [NSMutableDictionary new];
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
			NSString *name = [spriteDict objectForKey:@"name"];
			NSString *spriteSheetName = [spriteDict objectForKey:@"spriteSheetName"];
			NSString *animationFile = [spriteDict objectForKey:@"animationFile"];
			int z = [[spriteDict objectForKey:@"z"] intValue];
			CGPoint anchorPoint = [Utils stringToPoint:[spriteDict objectForKey:@"anchorPoint"]];
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
            
			RenderSprite *renderSprite = [renderSystem createRenderSpriteWithSpriteSheetName:spriteSheetName animationFile:animationFile z:z];
			[[renderSprite sprite] setAnchorPoint:anchorPoint];
            [renderSprite setDefaultIdleAnimationNames:defaultIdleAnimationNames];
            [renderSprite setDefaultDestroyAnimationNames:defaultDestroyAnimationNames];
			[self addRenderSprite:renderSprite withName:name];
			
            [renderSprite playDefaultIdleAnimation];
		}
	}
	return self;
}

-(void) dealloc
{
	[_renderSprites release];
    [_renderSpritesByName release];
    
    [super dealloc];
}

-(id) copyWithZone:(NSZone *)zone
{
	RenderComponent *copiedRenderComponent = [super copyWithZone:zone];
	for (NSString *name in _renderSprites)
	{
		RenderSprite *renderSprite = [_renderSpritesByName objectForKey:name];
		RenderSprite *copiedRenderSprite = [renderSprite copy];
		[copiedRenderComponent addRenderSprite:copiedRenderSprite withName:name];
		[copiedRenderSprite release];
	}
	return copiedRenderComponent;
}

-(void) addRenderSprite:(RenderSprite *)renderSprite withName:(NSString *)name
{
	[_renderSprites addObject:renderSprite];
	[_renderSpritesByName setObject:renderSprite forKey:name];
}

-(RenderSprite *) getRenderSprite:(NSString *)name
{
    return [_renderSpritesByName objectForKey:name];
}

-(RenderSprite *) firstRenderSprite
{
	return [_renderSprites objectAtIndex:0];
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
    for (RenderSprite *renderSprite in [_renderSpritesByName allValues])
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

-(void) playDefaultIdleAnimation
{
    for (RenderSprite *renderSprite in _renderSprites)
    {
        [renderSprite playDefaultIdleAnimation];
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
