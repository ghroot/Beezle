//
//  FollowControlSystem
//  Beezle
//
//  Created by marcus on 01/06/2012.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@class InputSystem;

@interface FollowControlSystem : EntityComponentSystem
{
	InputSystem *_inputSystem;
}

@end