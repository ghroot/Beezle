//
//  HealthSystem.h
//  Beezle
//
//  Created by KM Lagerstrom on 21/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@class NotificationProcessor;

@interface HealthSystem : EntityComponentSystem
{
	NotificationProcessor *_notificationProcessor;
}

@end
