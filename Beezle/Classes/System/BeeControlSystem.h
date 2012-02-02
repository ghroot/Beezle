//
//  BeeControlSystem.h
//  Beezle
//
//  Created by Me on 08/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@class InputSystem;

@interface BeeControlSystem : EntityComponentSystem
{
	InputSystem *_inputSystem;
}

@end
