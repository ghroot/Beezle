//
//  HealthSystem.m
//  Beezle
//
//  Created by KM Lagerstrom on 21/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HealthSystem.h"
#import "HealthComponent.h"
#import "EntityUtil.h"
#import "NotificationProcessor.h"
#import "NotificationTypes.h"
#import "RenderComponent.h"

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
	[_healthComponentMapper release];
	[_renderComponentMapper release];

	[_notificationProcessor release];
	
	[super dealloc];
}

-(void) initialise
{
	_healthComponentMapper = [[ComponentMapper alloc] initWithEntityManager:[_world entityManager] componentClass:[HealthComponent class]];
	_renderComponentMapper = [[ComponentMapper alloc] initWithEntityManager:[_world entityManager] componentClass:[RenderComponent class]];
}

-(void) activate
{
	[super activate];
	
	[_notificationProcessor activate];
}

-(void) deactivate
{
	[super deactivate];
	
	[_notificationProcessor deactivate];
}

-(void) begin
{
	[_notificationProcessor processNotifications];
}

-(void) entityAdded:(Entity *)entity
{
	HealthComponent *healthComponent = [_healthComponentMapper getComponentFor:entity];
	[healthComponent resetHealthPointsLeft];
}

-(void) handleEntityDisposed:(NSNotification *)notification
{
	Entity *entity = [[notification userInfo] objectForKey:@"entity"];
	if ([EntityUtil isEntityDisposed:entity] &&
		[entity hasComponent:[HealthComponent class]])
	{
		HealthComponent *healthComponent = [_healthComponentMapper getComponentFor:entity];
		[healthComponent deductHealthPoint];
		if ([healthComponent hasHealthPointsLeft])
		{
			[EntityUtil setEntityUndisposed:entity];

			RenderComponent *renderComponent = [_renderComponentMapper getComponentFor:entity];
			[renderComponent playDefaultHitAnimation];
		}
	}
}

@end
