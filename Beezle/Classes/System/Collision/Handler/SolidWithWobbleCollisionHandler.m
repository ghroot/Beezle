//
//  SolidWithWobbleCollisionHandler.m
//  Beezle
//
//  Created by KM Lagerstrom on 22/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SolidWithWobbleCollisionHandler.h"
#import "RenderComponent.h"
#import "RenderSprite.h"
#import "SolidComponent.h"
#import "WobbleComponent.h"
#import "DisposableComponent.h"
#import "EntityUtil.h"

@implementation SolidWithWobbleCollisionHandler

-(id) initWithWorld:(World *)world levelSession:(LevelSession *)levelSession
{
	if (self = [super initWithWorld:world levelSession:levelSession])
	{
		[_firstComponentClasses addObject:[SolidComponent class]];
		[_secondComponentClasses addObject:[WobbleComponent class]];
	}
	return self;
}

-(BOOL) handleCollisionBetween:(Entity *)firstEntity and:(Entity *)secondEntity collision:(Collision *)collision
{
	// TODO: Is there a nicer solution than opting out here?
	if ([EntityUtil isEntityDisposable:secondEntity] &&
			[[DisposableComponent getFrom:secondEntity] isAboutToBeDeleted])
	{
		return TRUE;
	}

	WobbleComponent *wobbleComponent = [WobbleComponent getFrom:secondEntity];
	RenderComponent *renderComponent = [RenderComponent getFrom:secondEntity];
	RenderSprite *defaultRenderSprite = [renderComponent defaultRenderSprite];
	
	if ([wobbleComponent hasWobbled])
	{
		[defaultRenderSprite playAnimationsLoopLast:[NSArray arrayWithObjects:[wobbleComponent randomWobbleAnimationName], [wobbleComponent randomWobbleFollowupAnimationName], nil]];
	}
	else
	{
		[defaultRenderSprite playAnimationsLoopLast:[NSArray arrayWithObjects:[wobbleComponent randomFirstWobbleAnimationName], [wobbleComponent randomWobbleFollowupAnimationName], nil]];
		[wobbleComponent setHasWobbled:TRUE];
	}
	
	return TRUE;
}

@end
