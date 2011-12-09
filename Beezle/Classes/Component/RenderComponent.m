//
//  RenderableBehaviour.m
//  Beezle
//
//  Created by Me on 06/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RenderComponent.h"
#import "RenderSprite.h"

@implementation RenderComponent

+(RenderComponent *) componentWithRenderSprite:(RenderSprite *)renderSprite
{
	RenderComponent *renderComponent = [[[RenderComponent alloc] init] autorelease];
	[renderComponent addRenderSprite:renderSprite withName:@"default"];
	return renderComponent;
}

-(id) init
{
	if (self = [super init])
	{
		_renderSpritesByName = [[NSMutableDictionary alloc] init];
	}
	return self;
}

-(void) dealloc
{
    [_renderSpritesByName release];
    
    [super dealloc];
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

-(void) playAnimation:(NSString *)animationName withLoops:(int)nLoops
{
	// TEMP: Simply forward to first render sprite for now
	RenderSprite *firstRenderSprite = (RenderSprite *)[[self renderSprites] objectAtIndex:0];
	[firstRenderSprite playAnimation:animationName withLoops:nLoops];
}

-(void) playAnimation:(NSString *)animationName
{
	// TEMP: Simply forward to first render sprite for now
	RenderSprite *firstRenderSprite = (RenderSprite *)[[self renderSprites] objectAtIndex:0];
	[firstRenderSprite playAnimation:animationName];
}

-(void) playAnimation:(NSString *)animationName withCallbackTarget:(id)target andCallbackSelector:(SEL)selector
{
	// TEMP: Simply forward to first render sprite for now
	RenderSprite *firstRenderSprite = (RenderSprite *)[[self renderSprites] objectAtIndex:0];
	[firstRenderSprite playAnimation:animationName withCallbackTarget:target andCallbackSelector:selector];
}

-(void) playAnimationsLoopLast:(NSArray *)animationNames
{
	// TEMP: Simply forward to first render sprite for now
	RenderSprite *firstRenderSprite = (RenderSprite *)[[self renderSprites] objectAtIndex:0];
	[firstRenderSprite playAnimationsLoopLast:animationNames];
}

-(void) playAnimationsLoopAll:(NSArray *)animationNames
{
	// TEMP: Simply forward to first render sprite for now
	RenderSprite *firstRenderSprite = (RenderSprite *)[[self renderSprites] objectAtIndex:0];
	[firstRenderSprite playAnimationsLoopAll:animationNames];
}

@end
