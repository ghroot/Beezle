//
//  ExplodeControlSystem.h
//  Beezle
//
//  Created by Me on 08/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@class InputSystem;
@class PhysicsSystem;

@interface ExplodeControlSystem : EntityComponentSystem
{
	InputSystem *_inputSystem;
	PhysicsSystem *_physicsSystem;
}

@end
