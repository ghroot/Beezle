//
//  SandSystem.m
//  Beezle
//
//  Created by Marcus Lagerstrom on 07/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SandSystem.h"
#import "NotificationProcessor.h"
#import "SandComponent.h"
#import "NotificationTypes.h"
#import "CapturedComponent.h"
#import "BeeType.h"
#import "EntityUtil.h"
#import "CGPointExtension.h"
#import "TransformComponent.h"

@interface SandSystem()

-(void) handleEntityDisposed:(NSNotification *)notification;

@end

@implementation SandSystem

-(id) init
{
	if (self = [super initWithUsedComponentClass:[SandComponent class]])
	{
		_notificationProcessor = [[NotificationProcessor alloc] initWithTarget:self];
		[_notificationProcessor registerNotification:GAME_NOTIFICATION_ENTITY_DISPOSED withSelector:@selector(handleEntityDisposed:)];
	}
	return self;
}

-(void) dealloc
{
	[_capturedComponentMapper release];
	[_sandComponentMapper release];
	[_transformComponentMapper release];

	[_notificationProcessor release];

	[super dealloc];
}

-(void) initialise
{
	_capturedComponentMapper = [[ComponentMapper alloc] initWithEntityManager:[_world entityManager] componentClass:[CapturedComponent class]];
	_sandComponentMapper = [[ComponentMapper alloc] initWithEntityManager:[_world entityManager] componentClass:[SandComponent class]];
	_transformComponentMapper = [[ComponentMapper alloc] initWithEntityManager:[_world entityManager] componentClass:[TransformComponent class]];
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
	if ([_capturedComponentMapper hasEntityComponent:entity])
	{
		TransformComponent *transformComponent = [_transformComponentMapper getComponentFor:entity];
		CapturedComponent *capturedComponent = [_capturedComponentMapper getComponentFor:entity];
		BeeType *beeType = [capturedComponent containedBeeType];
		if (beeType == [BeeType MUMEE])
		{
			Entity *closestEntity = nil;
			float closestDistance = -1.0f;
			for (Entity *otherEntity in [[_world entityManager] entities])
			{
				if ([_sandComponentMapper hasEntityComponent:otherEntity])
				{
					TransformComponent *otherTransformComponent = [_transformComponentMapper getComponentFor:otherEntity];
					float distance = ccpDistance([transformComponent position], [otherTransformComponent position]);
					if (closestDistance < 0.0f || distance < closestDistance)
					{
						closestEntity = otherEntity;
						closestDistance = distance;
					}
				}
			}
			if (closestEntity != nil)
			{
				[EntityUtil destroyEntity:closestEntity];
			}
		}
	}
}

@end
