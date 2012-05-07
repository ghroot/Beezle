//
//  BeeaterAnimationSystem.h
//  Beezle
//
//  Created by KM Lagerstrom on 09/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@class NotificationProcessor;

@interface BeeaterSystem : EntityComponentSystem
{
	NotificationProcessor *_notificationProcessor;
}

-(void) animateBeeater:(Entity *)beeaterEntity;

@end
