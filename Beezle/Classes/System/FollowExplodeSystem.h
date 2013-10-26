//
// Created by Marcus on 2013-10-10.
//

#import "artemis.h"

@class PhysicsSystem;

@interface FollowExplodeSystem : EntityComponentSystem
{
	PhysicsSystem *_physicsSystem;
}

@end