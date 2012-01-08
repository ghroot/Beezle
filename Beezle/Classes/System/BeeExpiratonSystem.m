//
//  BeeSystem.m
//  Beezle
//
//  Created by Me on 02/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BeeExpiratonSystem.h"
#import "BeeComponent.h"
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
    PhysicsComponent *physicsComponent = (PhysicsComponent *)[entity getComponent:[PhysicsComponent class]];
	
	if ([[physicsComponent body] isSleeping])
	{
        // Crash animation (and delete entity at end of animation)
        RenderComponent *rampRenderComponent = (RenderComponent *)[entity getComponent:[RenderComponent class]];
        [rampRenderComponent playAnimation:@"Bee-Crash" withCallbackTarget:entity andCallbackSelector:@selector(deleteEntity)];
        
        // Disable physics component
        [physicsComponent disable];
        [entity refresh];
		
		// Game notification
		[[NSNotificationCenter defaultCenter] postNotificationName:GAME_NOTIFICATION_BEE_EXPIRED object:self];
	}
}

@end
