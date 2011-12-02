//
//  BeeSystem.m
//  Beezle
//
//  Created by Me on 02/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BeeSystem.h"
#import "BeeComponent.h"
#import "PhysicsBody.h"
#import "PhysicsComponent.h"
#import "PhysicsShape.h"
#import "RenderComponent.h"

@implementation BeeSystem

-(id) init
{
    self = [super initWithUsedComponentClasses:[NSArray arrayWithObjects:[BeeComponent class], [PhysicsComponent class], nil]];
    return self;
}

-(void) processEntity:(Entity *)entity
{
    PhysicsComponent *physicsComponent = (PhysicsComponent *)[entity getComponent:[PhysicsComponent class]];
	
	PhysicsBody *physicsBody = [physicsComponent physicsBody];
	cpBody *body = [physicsBody body];
	if (cpBodyIsSleeping(body))
	{
        // Crash animation (and delete entity at end of animation)
        RenderComponent *rampRenderComponent = (RenderComponent *)[entity getComponent:[RenderComponent class]];
        [rampRenderComponent playAnimation:@"Bee-Crash" withCallbackTarget:entity andCallbackSelector:@selector(deleteEntity)];
        
        // Disable physics component
        [physicsComponent disable];
        [entity refresh];
	}
}

@end
