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
	[_disposalComponentMapper release];
	[_renderComponentMapper release];

	[_notificationProcessor release];
	
	[super dealloc];
}

-(void) initialise
{
	_disposalComponentMapper = [[ComponentMapper alloc] initWithEntityManager:[_world entityManager] componentClass:[DisposableComponent class]];
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

-(void) handleEntityDisposed:(NSNotification *)notification
{
	Entity *entity = [[notification userInfo] objectForKey:@"entity"];
	if ([EntityUtil isEntityDisposed:entity])
	{
		DisposableComponent *disposalComponent = [_disposalComponentMapper getComponentFor:entity];
		if ([disposalComponent deleteEntityWhenDisposed] &&
			![disposalComponent isAboutToBeDeleted])
		{
			RenderComponent *renderComponent = [_renderComponentMapper getComponentFor:entity];
			if ([renderComponent hasDefaultDestroyAnimation])
			{
				if ([disposalComponent keepEntityDisabledInsteadOfDelete])
				{
					[renderComponent playDefaultDestroyAnimation];
					[EntityUtil disablePhysics:entity];
				}
				else
				{
					[EntityUtil animateAndDeleteEntity:entity];
				}
			}
			else
			{
				if ([disposalComponent keepEntityDisabledInsteadOfDelete])
				{
					[EntityUtil disablePhysics:entity];
				}
				else
				{
					[entity deleteEntity];
				}
			}
		}
	}
}

@end
