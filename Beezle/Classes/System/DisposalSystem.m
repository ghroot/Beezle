//
//  DisposalSystem.m
//  Beezle
//
//  Created by KM Lagerstrom on 17/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DisposalSystem.h"
#import "DisposableComponent.h"
#import "EntityUtil.h"
#import "NotificationProcessor.h"
#import "NotificationTypes.h"
#import "RenderComponent.h"

@interface DisposalSystem()

-(void) handleEntityDisposed:(NSNotification *)notification;

@end

@implementation DisposalSystem

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
    DisposableComponent *disposalComponent = [DisposableComponent getFrom:entity];
    if ([disposalComponent deleteEntityWhenDisposed])
    {
        if ([[RenderComponent getFrom:entity] hasDefaultDestroyAnimation])
        {
            [EntityUtil animateAndDeleteEntity:entity];
        }
        else
        {
            [entity deleteEntity];
        }
    }
}

@end
