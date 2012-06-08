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
	ComponentMapper *_physicsComponentMapper;
	ComponentMapper *_freezableComponentMapper;
	ComponentMapper *_renderComponentMapper;
	PhysicsSystem *_physicsSystem;
}

@end
