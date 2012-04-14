//
//  CrumbleSystem.m
//  Beezle
//
//  Created by Marcus on 4/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CrumbleSystem.h"
#import "CrumbleComponent.h"
#import "EntityUtil.h"
#import "NotificationProcessor.h"
#import "NotificationTypes.h"

@interface CrumbleSystem()

-(void) handleEntityDisposed:(NSNotification *)notification;

@end

@implementation CrumbleSystem

-(id) init
{
    if (self = [super init])
    {
		_notificationProcessor = [[NotificationProcessor alloc] initWithTarget:self];
		[_notificationProcessor registerNotification:GAME_NOTIFICATION_ENTITY_DISPOSED withSelector:@selector(handleEntityDisposed:)];
    }
    return self;
}

-(void) dealloc
{
	[_notificationProcessor release];
	
	[super dealloc];
}

-(void) begin
{
	[_notificationProcessor processNotifications];
}

-(void) handleEntityDisposed:(NSNotification *)notification
{
    Entity *entity = [[notification userInfo] objectForKey:@"entity"];
	if ([entity hasComponent:[CrumbleComponent class]])
	{
        CrumbleComponent *crumbleComponent = [CrumbleComponent getFrom:entity];
        if ([crumbleComponent crumbleAnimationName] != nil)
        {
            [EntityUtil animateAndDeleteEntity:entity animationName:[crumbleComponent crumbleAnimationName]];
        }
	}
}

@end
