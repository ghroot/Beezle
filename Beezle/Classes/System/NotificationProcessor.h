//
//  NotificationProcessor.h
//  Beezle
//
//  Created by KM Lagerstrom on 14/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@interface NotificationProcessor : NSObject
{
	NSMutableArray *_notifications;
    NSMutableDictionary *_selectorsByNotificationNames;
	id _target;
}

-(id) initWithTarget:(id)target;

-(void) registerNotification:(NSString *)name withSelector:(SEL)selector;
-(void) processNotifications;

@end
