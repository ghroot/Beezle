//
//  DisposalSystem.h
//  Beezle
//
//  Created by KM Lagerstrom on 17/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@class NotificationProcessor;

@interface DisposalSystem : EntitySystem
{
	NotificationProcessor *_notificationProcessor;
}

@end
