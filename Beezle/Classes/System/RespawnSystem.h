//
// Created by Marcus on 04/12/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "artemis.h"

@class NotificationProcessor;

@interface RespawnSystem : EntityComponentSystem
{
	NotificationProcessor *_notificationProcessor;

	NSMutableArray *_respawnInfos;
}

@end
