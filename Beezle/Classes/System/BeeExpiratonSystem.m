//
//  BeeSystem.m
//  Beezle
//
//  Created by Me on 02/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BeeExpiratonSystem.h"
#import "BeeComponent.h"
#import "DisposableComponent.h"
#import "EntityUtil.h"
#import "PhysicsComponent.h"

@implementation BeeExpiratonSystem

-(id) init
{
    self = [super initWithUsedComponentClasses:[NSArray arrayWithObjects:[BeeComponent class], [PhysicsComponent class], [DisposableComponent class], nil]];
    return self;
}

-(void) entityAdded:(Entity *)entity
{
	[[BeeComponent getFrom:entity] resetAutoDestroyCountdown];
}

-(void) processEntity:(Entity *)entity
{
	if (![EntityUtil isEntityDisposed:entity])
	{
		BOOL shouldExpire = FALSE;
		
		BeeComponent *beeComponent = [BeeComponent getFrom:entity];
		[beeComponent decreaseAutoDestroyCountdown:[_world delta]];
		if ([beeComponent didAutoDestroyCountdownReachZero])
		{
			shouldExpire = TRUE;
		}
		
		PhysicsComponent *physicsComponent = [PhysicsComponent getFrom:entity];
		if ([[physicsComponent body] isSleeping])
		{
			shouldExpire = TRUE;
		}
		
		if (shouldExpire)
		{
			[EntityUtil setEntityDisposed:entity];
			[EntityUtil animateAndDeleteEntity:entity];
		}
	}
}

@end
