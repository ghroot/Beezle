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
	WobbleComponent *wobbleComponent = [WobbleComponent getFrom:secondEntity];
	RenderComponent *renderComponent = [RenderComponent getFrom:secondEntity];
	RenderSprite *defaultRenderSprite = [renderComponent defaultRenderSprite];
	[defaultRenderSprite playAnimationsLoopLast:[NSArray arrayWithObjects:[wobbleComponent randomWobbleAnimationName], [defaultRenderSprite randomDefaultIdleAnimationName], nil]];
	
	return TRUE;
}

@end
