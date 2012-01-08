//
//  BeeControlSystem.m
//  Beezle
//
//  Created by Me on 08/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BeeControlSystem.h"
#import "BeeComponent.h"
#import "BeeTypes.h"
#import "InputAction.h"
#import "InputSystem.h"
#import "PhysicsComponent.h"
#import "RenderComponent.h"
#import "TransformComponent.h"

@implementation BeeControlSystem

-(id) init
{
    self = [super initWithUsedComponentClasses:[NSArray arrayWithObjects:[BeeComponent class], nil]];
    return self;
}

-(void) processEntity:(Entity *)entity
{
	InputSystem *inputSystem = (InputSystem *)[[_world systemManager] getSystem:[InputSystem class]];
    if ([inputSystem hasInputActions])
    {
        InputAction *nextInputAction = [inputSystem popInputAction];
		BeeComponent *beeComponent = (BeeComponent *)[entity getComponent:[BeeComponent class]];
		if ([[beeComponent type] canExplode] &&
			[nextInputAction touchType] == TOUCH_BEGAN)
		{
			LabelManager *labelManager = (LabelManager *)[_world getManager:[LabelManager class]];
			for (Entity *otherEntity in [[_world entityManager] entities])
			{
				if ([labelManager hasEntity:otherEntity label:@"RAMP"])
				{
					TransformComponent *transformComponent = (TransformComponent *)[entity getComponent:[TransformComponent class]];
					TransformComponent *otherTransformComponent = (TransformComponent *)[otherEntity getComponent:[TransformComponent class]];
					if (ccpDistance([transformComponent position], [otherTransformComponent position]) <= 40)
					{
						[otherEntity deleteEntity];
					}
				}
			}
			
			RenderComponent *renderComponent = (RenderComponent *)[entity getComponent:[RenderComponent class]];
			[renderComponent playAnimation:@"Bee-Crash" withCallbackTarget:entity andCallbackSelector:@selector(deleteEntity)];
			PhysicsComponent *physicsComponent = (PhysicsComponent *)[entity getComponent:[PhysicsComponent class]];
			[physicsComponent disable];
			[entity refresh];
		}
	}
}

@end
