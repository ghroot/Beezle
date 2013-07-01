//
// Created by Marcus on 15/04/2013.
//

#import "SlingerGogglesSystem.h"
#import "SlingerComponent.h"
#import "RenderComponent.h"
#import "RenderSprite.h"

@implementation SlingerGogglesSystem

-(id) init
{
	self = [super initWithUsedComponentClasses:[NSArray arrayWithObject:[SlingerComponent class]]];
	return self;
}

-(void) dealloc
{
	[_slingerComponentMapper release];
	[_renderComponentMapper release];

	[super dealloc];
}

-(void) initialise
{
	_slingerComponentMapper = [[ComponentMapper alloc] initWithEntityManager:[_world entityManager] componentClass:[SlingerComponent class]];
	_renderComponentMapper = [[ComponentMapper alloc] initWithEntityManager:[_world entityManager] componentClass:[RenderComponent class]];
}

-(void) processEntity:(Entity *)entity
{
	SlingerComponent *slingerComponent = [_slingerComponentMapper getComponentFor:entity];
	RenderComponent *renderComponent = [_renderComponentMapper getComponentFor:entity];

	RenderSprite *gogglesBackRenderSprite = [renderComponent renderSpriteWithName:@"gogglesBack"];
	RenderSprite *gogglesFrontRenderSprite = [renderComponent renderSpriteWithName:@"gogglesFront"];
	if ([slingerComponent isGogglesActive])
	{
		[gogglesBackRenderSprite show];
		[gogglesFrontRenderSprite show];

		[gogglesBackRenderSprite playAnimationLoop:@"Slinger-Goggles-Back"];
		[gogglesFrontRenderSprite playAnimationLoop:@"Slinger-Goggles-Front"];
	}
	else
	{
		[gogglesBackRenderSprite hide];
		[gogglesFrontRenderSprite hide];
	}
}

@end