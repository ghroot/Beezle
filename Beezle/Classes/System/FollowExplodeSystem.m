//
// Created by Marcus on 2013-10-10.
//

#import "FollowExplodeSystem.h"
#import "PhysicsSystem.h"
#import "ExplodeComponent.h"
#import "FollowComponent.h"
#import "TransformComponent.h"

@implementation FollowExplodeSystem

-(id) init
{
	self = [super initWithUsedComponentClasses:[NSArray arrayWithObjects:[ExplodeComponent class], [FollowComponent class], nil]];
	return self;
}

-(void) initialise
{
	_physicsSystem = (PhysicsSystem *)[[_world systemManager] getSystem:[PhysicsSystem class]];
}

-(void) processEntity:(Entity *)entity
{
	FollowComponent *followComponent = [FollowComponent getFrom:entity];
	if ([followComponent state] == FOLLOW_CONTROL_STATE_ACTIVE)
	{
		TransformComponent *transformComponent = [TransformComponent getFrom:entity];
		if (ccpDistance([transformComponent position], [followComponent location]) <= 20.0f)
		{
			ExplodeComponent *explodeComponent = [ExplodeComponent getFrom:entity];
			if ([explodeComponent explosionState] == NOT_EXPLODED)
			{
				[explodeComponent setExplosionState:EXPLOSION_TRIGGERED];
			}
		}
	}
}

@end
