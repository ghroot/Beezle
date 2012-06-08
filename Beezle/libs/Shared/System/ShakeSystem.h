//
//  ShakeSystem.h
//  Beezle
//
//  Created by KM Lagerstrom on 21/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"
#import "cocos2d.h"

@class NotificationProcessor;

@interface ShakeSystem : EntitySystem
{
	ComponentMapper *_shakeComponentMapper;
	ComponentMapper *_renderComponentMapper;

	NotificationProcessor *_notificationProcessor;
}

@end
