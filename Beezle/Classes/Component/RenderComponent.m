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

@synthesize renderSprites = _renderSprites;

-(id) init
{
	if (self = [super init])
	{
		_renderSprites = [[NSMutableArray alloc] init];
	}
	return self;
}

-(void) dealloc
{
    [_renderSprites release];
    
    [super dealloc];
}

+(RenderComponent *) renderComponentWithRenderSprites:(NSArray *)renderSprites
{
	RenderComponent *renderComponent = [[[RenderComponent alloc] init] autorelease];
	for (RenderSprite *renderSprite in renderSprites)
	{
		[renderComponent addRenderSprite:renderSprite];
	}
	return renderComponent;
}

+(RenderComponent *) renderComponentWithRenderSprite:(RenderSprite *)renderSprite
{
	RenderComponent *renderComponent = [[[RenderComponent alloc] init] autorelease];
	[renderComponent addRenderSprite:renderSprite];
	return renderComponent;
}

-(void) addRenderSprite:(RenderSprite *)renderSprite
{
	[_renderSprites addObject:renderSprite];
}

-(void) playAnimation:(NSString *)animationName withLoops:(int)nLoops
{
	// TEMP: Simply forward to first render sprite for now
	RenderSprite *firstRenderSprite = (RenderSprite *)[_renderSprites objectAtIndex:0];
	[firstRenderSprite playAnimation:animationName withLoops:nLoops];
}

-(void) playAnimation:(NSString *)animationName withCallbackTarget:(id)target andCallbackSelector:(SEL)selector
{
	// TEMP: Simply forward to first render sprite for now
	RenderSprite *firstRenderSprite = (RenderSprite *)[_renderSprites objectAtIndex:0];
	[firstRenderSprite playAnimation:animationName withCallbackTarget:target andCallbackSelector:selector];
}

-(void) playAnimations:(NSArray *)animationNames
{
	// TEMP: Simply forward to first render sprite for now
	RenderSprite *firstRenderSprite = (RenderSprite *)[_renderSprites objectAtIndex:0];
	[firstRenderSprite playAnimations:animationNames];
}

@end
