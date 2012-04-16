//
//  WoodSystem.h
//  Beezle
//
//  Created by KM Lagerstrom on 15/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EntitySystem.h"

@class NotificationProcessor;

@interface WoodSystem : EntitySystem
{
	NotificationProcessor *_notificationProcessor;
}

@end
