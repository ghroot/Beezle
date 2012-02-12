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

+(RenderComponent *) componentWithContentsOfDictionary:(NSDictionary *)dict world:(World *)world
{
	return [[[self alloc] initWithContentsOfDictionary:dict world:world] autorelease];
}

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
		_renderSpritesByName = [[NSMutableDictionary alloc] init];
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
			NSString *defaultIdleAnimationName = [spriteDict objectForKey:@"defaultIdleAnimation"];
			
			RenderSprite *renderSprite = [renderSystem createRenderSpriteWithSpriteSheetName:spriteSheetName animationFile:animationFile z:z];
			[[renderSprite sprite] setAnchorPoint:anchorPoint];
			[_renderSpritesByName setObject:renderSprite forKey:name];
			
			if (defaultIdleAnimationName != nil)
			{
				[renderSprite playAnimation:defaultIdleAnimationName];
			}
		}
	}
	return self;
}

-(void) dealloc
{
    [_renderSpritesByName release];
    
    [super dealloc];
}

-(id) copyWithZone:(NSZone *)zone
{
	RenderComponent *copiedRenderComponent = [super copyWithZone:zone];
	for (NSString *name in [_renderSpritesByName allKeys])
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
	[_renderSpritesByName setObject:renderSprite forKey:name];
}

-(RenderSprite *) getRenderSprite:(NSString *)name
{
    return [_renderSpritesByName objectForKey:name];
}

-(NSArray *) renderSprites
{
    return [_renderSpritesByName allValues];
}

-(void) setAlpha:(float)alpha
{
	for (RenderSprite *renderSprite in [_renderSpritesByName allValues])
	{
		[[renderSprite sprite] setOpacity:(alpha * 256)];
	}
}

-(void) playAnimation:(NSString *)animationName withLoops:(int)nLoops
{
    for (RenderSprite *renderSprite in [_renderSpritesByName allValues])
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
    for (RenderSprite *renderSprite in [_renderSpritesByName allValues])
    {
        [renderSprite playAnimation:animationName withCallbackTarget:target andCallbackSelector:selector];
    }
}

-(void) playAnimationsLoopLast:(NSArray *)animationNames
{
    for (RenderSprite *renderSprite in [_renderSpritesByName allValues])
    {
        [renderSprite playAnimationsLoopLast:animationNames];
    }
}

-(void) playAnimationsLoopAll:(NSArray *)animationNames
{
    for (RenderSprite *renderSprite in [_renderSpritesByName allValues])
    {
        [renderSprite playAnimationsLoopAll:animationNames];
    }
}

@end
