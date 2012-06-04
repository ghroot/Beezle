//
//  DisintegrateControlSystem.h
//  Beezle
//
//  Created by Marcus Lagerstrom on 06/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@class InputSystem;

@interface DisintegrateControlSystem : EntityComponentSystem
{
	InputSystem *_inputSystem;
}

@end
