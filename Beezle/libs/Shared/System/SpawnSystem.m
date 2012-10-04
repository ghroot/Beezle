//
//  SpawnSystem.m
//  Beezle
//
//  Created by KM Lagerstrom on 10/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SpawnSystem.h"
#import "EntityFactory.h"
#import "EntityUtil.h"
#import "SpawnComponent.h"
#import "TransformComponent.h"
#import "NotificationProcessor.h"
#import "NotificationTypes.h"

@interface SpawnSystem()

-(void) handleEntityDisposed:(NSNotification *)notification;
-(void) spawn:(Entity *)entity;

@end

@implementation SpawnSystem

-(id) init
{
	if (self = [super initWithUsedComponentClasses:[NSArray arrayWithObjects:[SpawnComponent class], [TransformComponent class], nil]])
	{
		_notificationProcessor = [[NotificationProcessor alloc] initWithTarget:self];
		[_notificationProcessor registerNotification:GAME_NOTIFICATION_ENTITY_DISPOSED withSelector:@selector(handleEntityDisposed:)];
	}
	return self;
}

-(void) dealloc
{
	[_spawnComponentMapper release];
	[_transformComponentMapper release];

	[_notificationProcessor release];

	[super dealloc];
}

-(void) initialise
{
	_spawnComponentMapper = [[ComponentMapper alloc] initWithEntityManager:[_world entityManager] componentClass:[SpawnComponent class]];
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

-(void) entityAdded:(Entity *)entity
{
	SpawnComponent *spawnComponent = [_spawnComponentMapper getComponentFor:entity];
	if ([spawnComponent hasCountdown])
	{
		[spawnComponent resetCountdown];
	}
}

-(void) processEntity:(Entity *)entity
{
	SpawnComponent *spawnComponent = [_spawnComponentMapper getComponentFor:entity];
	if ([spawnComponent hasCountdown])
	{
		[spawnComponent decreaseCountdown:[_world delta] / 1000.0f];
		if ([spawnComponent didCountdownReachZero])
		{
			[self spawn:entity];
			[spawnComponent resetCountdown];
		}
	}
}

-(void) handleEntityDisposed:(NSNotification *)notification
{
	Entity *entity = [[notification userInfo] objectForKey:@"entity"];
	if ([_spawnComponentMapper hasEntityComponent:entity])
	{
		SpawnComponent *spawnComponent = [_spawnComponentMapper getComponentFor:entity];
		if ([spawnComponent spawnWhenDestroyed])
		{
			[self spawn:entity];
		}
	}
}

-(void) spawn:(Entity *)entity
{
	SpawnComponent *spawnComponent = [_spawnComponentMapper getComponentFor:entity];

	Entity *spawnedEntity = [EntityFactory createEntity:[spawnComponent entityType] world:_world];

	TransformComponent *transformComponent = [_transformComponentMapper getComponentFor:entity];
	CGPoint spawnPosition = [transformComponent position];
	spawnPosition.x += [spawnComponent offset].x;
	spawnPosition.y += [spawnComponent offset].y;
	[EntityUtil setEntityPosition:spawnedEntity position:spawnPosition];

	if ([spawnComponent keepRotation])
	{
		[EntityUtil setEntityRotation:spawnedEntity rotation:[transformComponent rotation]];
	}

	if ([spawnComponent autoDestroy])
	{
		[EntityUtil animateAndDeleteEntity:spawnedEntity];
	}
}

@end
