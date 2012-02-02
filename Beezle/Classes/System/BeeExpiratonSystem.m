//
//  BeeSystem.m
//  Beezle
//
//  Created by Me on 02/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BeeExpiratonSystem.h"
#import "BeeComponent.h"
#import "EntityUtil.h"
#import "NotificationTypes.h"
#import "PhysicsComponent.h"
#import "RenderComponent.h"

@implementation BeeExpiratonSystem

-(id) init
{
    self = [super initWithUsedComponentClasses:[NSArray arrayWithObjects:[BeeComponent class], [PhysicsComponent class], nil]];
    return self;
}

-(void) processEntity:(Entity *)entity
{
    PhysicsComponent *physicsComponent = [PhysicsComponent getFrom:entity];
	if ([[physicsComponent body] isSleeping])
	{
        [EntityUtil animateAndDeleteEntity:entity animationName:@"Bee-Crash"];
		
		// Game notification
		[[NSNotificationCenter defaultCenter] postNotificationName:GAME_NOTIFICATION_BEE_EXPIRED object:self];
	}
}

@end
