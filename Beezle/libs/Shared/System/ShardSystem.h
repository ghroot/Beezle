//
//  GlassAnimationSystem.h
//  Beezle
//
//  Created by KM Lagerstrom on 16/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"
#import "cocos2d.h"

@class NotificationProcessor;

@interface ShardSystem : EntityComponentSystem
{
	ComponentMapper *_shardComponentMapper;
	ComponentMapper *_physicsComponentMapper;

	NotificationProcessor *_notificationProcessor;
}

@end
