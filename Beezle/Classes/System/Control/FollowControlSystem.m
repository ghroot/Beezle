//
//  FollowControlSystem
//  Beezle
//
//  Created by marcus on 01/06/2012.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "FollowControlSystem.h"
#import "FollowComponent.h"
#import "InputSystem.h"
#import "TouchTypes.h"
#import "InputAction.h"
#import "PhysicsComponent.h"
#import "TransformComponent.h"
#import "Utils.h"
#import "EntityUtil.h"

static float FORCE_SCALE = 0.5f;

@implementation FollowControlSystem

-(id) init
{
	self = [super initWithUsedComponentClass:[FollowComponent class]];
	return self;
}

-(void) initialise
{
	_inputSystem = (InputSystem *)[[_world systemManager] getSystem:[InputSystem class]];
}

-(void) entityAdded:(Entity *)entity
{
	[[FollowComponent getFrom:entity] setState:FOLLOW_CONTROL_STATE_INACTIVE];
}

-(void) processEntity:(Entity *)entity
{
	FollowComponent *followComponent = [FollowComponent getFrom:entity];

	if ([followComponent state] == FOLLOW_CONTROL_STATE_ACTIVE)
	{
		TransformComponent *transformComponent = [TransformComponent getFrom:entity];
		CGPoint force = ccpSub([followComponent location], [transformComponent position]);
		CGPoint scaledForce = CGPointMake(force.x * FORCE_SCALE, force.y * FORCE_SCALE);

		PhysicsComponent *physicsComponent = [PhysicsComponent getFrom:entity];
		[[physicsComponent body] setForce:scaledForce];

		float forceAngle = ccpToAngle(scaledForce);
		float compatibleForceAngle = [Utils unwindAngleDegrees:360 - CC_RADIANS_TO_DEGREES(forceAngle) + 270];
		if (compatibleForceAngle < 180)
		{
			[EntityUtil setEntityMirrored:entity mirrored:TRUE];
			compatibleForceAngle += 180;
		}
		else
		{
			[EntityUtil setEntityMirrored:entity mirrored:FALSE];
		}
		[EntityUtil setEntityRotation:entity rotation:compatibleForceAngle + 90];
	}

	while ([_inputSystem hasInputActions])
	{
		InputAction *inputAction = [_inputSystem popInputAction];
		switch ([inputAction touchType])
		{
			case TOUCH_BEGAN:
			{
				if ([followComponent state] == FOLLOW_CONTROL_STATE_INACTIVE)
				{
					[followComponent setLocation:[inputAction touchLocation]];
					[followComponent setState:FOLLOW_CONTROL_STATE_ACTIVE];
				}
				break;
			}
			case TOUCH_MOVED:
			{
				if ([followComponent state] == FOLLOW_CONTROL_STATE_ACTIVE)
				{
					[followComponent setLocation:[inputAction touchLocation]];
				}
				break;
			}
			case TOUCH_ENDED:
			case TOUCH_CANCELLED:
			{
				if ([followComponent state] == FOLLOW_CONTROL_STATE_ACTIVE)
				{
					// TODO: Destroy bee?

					[followComponent setState:FOLLOW_CONTROL_STATE_INACTIVE];
				}
				break;
			}
		}
	}
}

@end