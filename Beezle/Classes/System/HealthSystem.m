//
//  HealthSystem.m
//  Beezle
//
//  Created by KM Lagerstrom on 21/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HealthSystem.h"
#import "HealthComponent.h"
#import "DisposableComponent.h"
#import "EntityUtil.h"
#import "NotificationProcessor.h"
#import "NotificationTypes.h"

@interface HealthSystem()

-(void) handleEntityDisposed:(NSNotification *)notification;

@end

@implementation HealthSystem

-(id) init
{
	if (self = [super initWithUsedComponentClasses:[NSArray arrayWithObject:[HealthComponent class]]])
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

-(void) entityAdded:(Entity *)entity
{
	HealthComponent *healthComponent = [HealthComponent getFrom:entity];
	[healthComponent resetHealthPointsLeft];
}

-(void) handleEntityDisposed:(NSNotification *)notification
{
	Entity *entity = [[notification userInfo] objectForKey:@"entity"];
	if ([EntityUtil isEntityDisposed:entity] &&
		[entity hasComponent:[HealthComponent class]])
	{
		HealthComponent *healthComponent = [HealthComponent getFrom:entity];
		[healthComponent deductHealthPoint];
		if ([healthComponent hasHealthPointsLeft])
		{
			[EntityUtil setEntityUndisposed:entity];
		}
	}
}

@end
