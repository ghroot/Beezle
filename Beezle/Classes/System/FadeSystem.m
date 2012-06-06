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

-(void) entityAdded:(Entity *)entity
{
	FadeComponent *fadeComponent = [FadeComponent getFrom:entity];
	[fadeComponent resetCountdown];
	[self ensureAnimation:entity];
}


-(void) processEntity:(Entity *)entity
{
	FadeComponent *fadeComponent = [FadeComponent getFrom:entity];
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
	FadeComponent *fadeComponent = [FadeComponent getFrom:entity];
	if (![[fadeComponent currentAnimationName] isEqualToString:[fadeComponent targetAnimationName]])
	{
		RenderComponent *renderComponent = [RenderComponent getFrom:entity];
		RenderSprite *defaultRenderSprite = [renderComponent defaultRenderSprite];
		[defaultRenderSprite playAnimationLoop:[fadeComponent targetAnimationName]];

		[fadeComponent setCurrentAnimationName:[fadeComponent targetAnimationName]];
	}
}

@end
