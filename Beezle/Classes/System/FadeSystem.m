//
//  FadeSystem
//  Beezle
//
//  Created by marcus on 06/06/2012.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "FadeSystem.h"
#import "FadeComponent.h"
#import "EntityUtil.h"
#import "RenderComponent.h"
#import "RenderSprite.h"

@interface FadeSystem()

-(void) ensureAnimation:(Entity *)entity;

@end

@implementation FadeSystem

-(id) init
{
	self = [super initWithUsedComponentClass:[FadeComponent class]];
	return self;
}

-(void) dealloc
{
	[_fadeComponentMapper release];
	[_renderComponentMapper release];

	[super dealloc];
}

-(void) initialise
{
	_fadeComponentMapper = [[ComponentMapper alloc] initWithEntityManager:[_world entityManager] componentClass:[FadeComponent class]];
	_renderComponentMapper = [[ComponentMapper alloc] initWithEntityManager:[_world entityManager] componentClass:[RenderComponent class]];
}

-(void) entityAdded:(Entity *)entity
{
	FadeComponent *fadeComponent = [_fadeComponentMapper getComponentFor:entity];
	[fadeComponent resetCountdown];
	[self ensureAnimation:entity];
}

-(void) processEntity:(Entity *)entity
{
	FadeComponent *fadeComponent = [_fadeComponentMapper getComponentFor:entity];
	if (![fadeComponent hasCountdownReachedZero])
	{
		[fadeComponent decreaseCountdown:[_world delta] / 1000.0f];
		if ([fadeComponent hasCountdownReachedZero])
		{
			[EntityUtil destroyEntity:entity];
		}
		else
		{
			[self ensureAnimation:entity];
		}
	}
}

-(void) ensureAnimation:(Entity *)entity
{
	FadeComponent *fadeComponent = [_fadeComponentMapper getComponentFor:entity];
	if (![[fadeComponent currentAnimationName] isEqualToString:[fadeComponent targetAnimationName]])
	{
		RenderComponent *renderComponent = [_renderComponentMapper getComponentFor:entity];
		RenderSprite *defaultRenderSprite = [renderComponent defaultRenderSprite];

		if ([fadeComponent targetAnimationIndex] == 0)
		{
			[defaultRenderSprite playAnimationsLoopLast:[NSArray arrayWithObjects:[fadeComponent introAnimationName], [fadeComponent targetAnimationName], nil]];
		}
		else
		{
			[defaultRenderSprite playAnimationLoop:[fadeComponent targetAnimationName]];
		}

		[fadeComponent setCurrentAnimationName:[fadeComponent targetAnimationName]];
	}
}

@end
