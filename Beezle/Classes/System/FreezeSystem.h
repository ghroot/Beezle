//
//  FreezeSystem.h
//  Beezle
//
//  Created by KM Lagerstrom on 10/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@class PhysicsSystem;

@interface FreezeSystem : EntityComponentSystem
{
	PhysicsSystem *_physicsSystem;
}

@end
