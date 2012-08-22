//
//  FreezeSystem.m
//  Beezle
//
//  Created by KM Lagerstrom on 10/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FreezeSystem.h"
#import "FreezableComponent.h"
#import "FreezeComponent.h"
#import "NotificationTypes.h"
#import "PhysicsComponent.h"
#import "PhysicsSystem.h"
#import "RenderComponent.h"

@implementation FreezeSystem

-(id) init
{
	self = [super initWithUsedComponentClasses:[NSArray arrayWithObjects:[FreezableComponent class], [PhysicsComponent class], nil]];
	return self;
}

-(void) dealloc
{
	[_physicsComponentMapper release];
	[_freezableComponentMapper release];
	[_renderComponentMapper release];

	[super dealloc];
}

-(void) initialise
{
	_physicsComponentMapper = [[ComponentMapper alloc] initWithEntityManager:[_world entityManager] componentClass:[PhysicsComponent class]];
	_freezableComponentMapper = [[ComponentMapper alloc] initWithEntityManager:[_world entityManager] componentClass:[FreezableComponent class]];
	_renderComponentMapper = [[ComponentMapper alloc] initWithEntityManager:[_world entityManager] componentClass:[RenderComponent class]];
	_physicsSystem = (PhysicsSystem *)[[_world systemManager] getSystem:[PhysicsSystem class]];
}

-(void) processEntity:(Entity *)entity
{
	PhysicsComponent *physicsComponent = [_physicsComponentMapper getComponentFor:entity];

	BOOL isTouchingAtLeastOneFreezeEntity = FALSE;
	
	for (ChipmunkShape *shape in [physicsComponent shapes])
	{
		cpLayers currentLayers = [shape layers];
		id currentGroup = [shape group];
		[shape setLayers:CP_ALL_LAYERS];
		[shape setGroup:nil];
		NSArray *shapeQueryInfos = [[_physicsSystem space] shapeQueryAll:shape];
		[shape setLayers:currentLayers];
		[shape setGroup:currentGroup];
		
		for (ChipmunkShapeQueryInfo *shapeQueryInfo in shapeQueryInfos)
		{
			Entity *otherEntity = [[shapeQueryInfo shape] data];
			if (otherEntity != nil &&
				[otherEntity hasComponent:[FreezeComponent class]])
			{
				isTouchingAtLeastOneFreezeEntity = TRUE;
				break;
			}
			if (isTouchingAtLeastOneFreezeEntity)
			{
				break;
			}
		}
	}
	
	FreezableComponent *freezableComponent = [_freezableComponentMapper getComponentFor:entity];
	if (isTouchingAtLeastOneFreezeEntity)
	{
		if (![freezableComponent isFrozen])
		{
			[freezableComponent setIsFrozen:TRUE];

			RenderComponent *renderComponent = [_renderComponentMapper getComponentFor:entity];
			[renderComponent playDefaultStillAnimation];

			NSDictionary *notificationUserInfo = [NSDictionary dictionaryWithObject:entity forKey:@"entity"];
			[[NSNotificationCenter defaultCenter] postNotificationName:GAME_NOTIFICATION_ENTITY_FROZEN object:self userInfo:notificationUserInfo];
		}
	}
	else
	{
		if ([freezableComponent isFrozen])
		{
			[freezableComponent setIsFrozen:FALSE];

			RenderComponent *renderComponent = [_renderComponentMapper getComponentFor:entity];
			[renderComponent playDefaultIdleAnimation];

			NSDictionary *notificationUserInfo = [NSDictionary dictionaryWithObject:entity forKey:@"entity"];
			[[NSNotificationCenter defaultCenter] postNotificationName:GAME_NOTIFICATION_ENTITY_UNFROZEN object:self userInfo:notificationUserInfo];
		}
	}
}

@end
