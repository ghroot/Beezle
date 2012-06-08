//
//  MovementSystem.h
//  Beezle
//
//  Created by KM Lagerstrom on 28/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EntityComponentSystem.h"
#import "cocos2d.h"

@class NotificationProcessor;
@class ComponentMapper;

@interface MovementSystem : EntityComponentSystem
{
	ComponentMapper *_movementComponentMapper;
	ComponentMapper *_transformComponentMapper;
	ComponentMapper *_physicsComponentMapper;

	NotificationProcessor *_notificationProcessor;
}

@end
