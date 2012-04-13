//
//  NotificationEntitySystem.h
//  Beezle
//
//  Created by Marcus on 4/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@interface NotificationEntitySystem : EntitySystem
{
	NSMutableArray *_notifications;
    NSMutableDictionary *_selectorsByNotificationNames;
}

-(void) addNotificationObserver:(NSString *)name selector:(SEL)selector;

@end
