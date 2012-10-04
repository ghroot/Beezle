//
//  SpawnSystem.h
//  Beezle
//
//  Created by KM Lagerstrom on 10/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@class NotificationProcessor;

@interface SpawnSystem : EntityComponentSystem
{
	ComponentMapper *_spawnComponentMapper;
	ComponentMapper *_transformComponentMapper;

	NotificationProcessor *_notificationProcessor;
}

@end
