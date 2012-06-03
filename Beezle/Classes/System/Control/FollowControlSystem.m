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
#import "EntityUtil.h"
#import "Utils.h"

static const float IMPULSE_SCALE = 0.4f;

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

	while ([_inputSystem hasInputActions])
	{
		InputAction *nextInputAction = [_inputSystem popInputAction];
		switch ([nextInputAction touchType])
		{
			case TOUCH_BEGAN:
			{
				if ([followComponent state] == FOLLOW_CONTROL_STATE_INACTIVE)
				{
					[followComponent setStartLocation:[nextInputAction touchLocation]];
					[followComponent setState:FOLLOW_CONTROL_STATE_ACTIVE];
				}
				break;
			}
			case TOUCH_MOVED:
			{
				break;
			}
			case TOUCH_ENDED:
			{
				if ([followComponent state] == FOLLOW_CONTROL_STATE_ACTIVE)
				{
					CGPoint touchVector = ccpSub([nextInputAction touchLocation], [followComponent startLocation]);

					CGPoint impulse = CGPointMake(touchVector.x * IMPULSE_SCALE, touchVector.y * IMPULSE_SCALE);

					PhysicsComponent *physicsComponent = [PhysicsComponent getFrom:entity];
					[[physicsComponent body] applyImpulse:impulse offset:CGPointZero];

					float impulseAngle = ccpToAngle(impulse);
					float compatibleImpulseAngle = [Utils unwindAngleDegrees:360 - CC_RADIANS_TO_DEGREES(impulseAngle) + 270];
					[EntityUtil setEntityRotation:entity rotation:compatibleImpulseAngle + 90];

					[followComponent setState:FOLLOW_CONTROL_STATE_INACTIVE];
				}
				break;
			}
			case TOUCH_CANCELLED:
			{
				break;
			}
		}
	}
}

@end