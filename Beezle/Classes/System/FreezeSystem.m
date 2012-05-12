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

@implementation FreezeSystem

-(id) init
{
	self = [super initWithUsedComponentClass:[FreezableComponent class]];
	return self;
}

-(void) processEntity:(Entity *)entity
{
	PhysicsComponent *freezablePhysicsComponent = [PhysicsComponent getFrom:entity];	
	cpBB freezableBB = [freezablePhysicsComponent boundingBox];
	
	BOOL isTouchingAtLeastOneFreezeEntity = FALSE;
	for (Entity *otherEntity in [[_world entityManager] entities])
	{
		if ([otherEntity hasComponent:[FreezeComponent class]] &&
			[otherEntity hasComponent:[PhysicsComponent class]])
		{
			PhysicsComponent *freezePhysicsComponent = [PhysicsComponent getFrom:otherEntity];	
			cpBB freezeBB = [freezePhysicsComponent boundingBox];
			if (cpBBIntersects(freezeBB, freezableBB))
			{
				isTouchingAtLeastOneFreezeEntity = TRUE;
				break;
			}
		}
	}

	FreezableComponent *freezableComponent = [FreezableComponent getFrom:entity];
	if (isTouchingAtLeastOneFreezeEntity)
	{
		if (![freezableComponent isFrozen])
		{
			[freezableComponent setIsFrozen:TRUE];
			
			NSDictionary *notificationUserInfo = [NSDictionary dictionaryWithObject:entity forKey:@"entity"];
			[[NSNotificationCenter defaultCenter] postNotificationName:GAME_NOTIFICATION_ENTITY_FROZEN object:self userInfo:notificationUserInfo];
		}
	}
	else
	{
		if ([freezableComponent isFrozen])
		{
			[freezableComponent setIsFrozen:FALSE];
			
			NSDictionary *notificationUserInfo = [NSDictionary dictionaryWithObject:entity forKey:@"entity"];
			[[NSNotificationCenter defaultCenter] postNotificationName:GAME_NOTIFICATION_ENTITY_UNFROZEN object:self userInfo:notificationUserInfo];
		}
	}
}

@end
