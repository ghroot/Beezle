//
//  SpawnSystem.h
//  Beezle
//
//  Created by KM Lagerstrom on 10/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@interface SpawnSystem : EntityComponentSystem
{
	ComponentMapper *_spawnComponentMapper;
	ComponentMapper *_transformComponentMapper;
}

@end
