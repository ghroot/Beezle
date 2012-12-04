//
//  SandSystem.h
//  Beezle
//
//  Created by Marcus Lagerstrom on 07/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@class NotificationProcessor;

@interface SandSystem : EntityComponentSystem
{
	ComponentMapper *_capturedComponentMapper;
	ComponentMapper *_sandComponentMapper;
	ComponentMapper *_transformComponentMapper;

	NotificationProcessor *_notificationProcessor;
}

@end
