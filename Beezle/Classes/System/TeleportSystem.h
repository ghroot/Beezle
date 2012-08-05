//
//  TeleportSystem.h
//  Beezle
//
//  Created by Marcus Lagerstrom on 08/05/12.
//Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@interface TeleportSystem : EntityComponentSystem
{
	ComponentMapper *_teleportComponentMapper;
	ComponentMapper *_transformComponentMapper;
	ComponentMapper *_physicsComponentMapper;
}

@end
