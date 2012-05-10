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
	self = [super initWithUsedComponentClass:[FreezeComponent class]];
	return self;
}

-(void) processEntity:(Entity *)entity
{
	PhysicsComponent *freezePhysicsComponent = [PhysicsComponent getFrom:entity];	
	cpBB freezeBB = [freezePhysicsComponent boundingBox];
	
	for (Entity *otherEntity in [[_world entityManager] entities])
	{
		if ([otherEntity hasComponent:[FreezableComponent class]])
		{
			FreezableComponent *freezableComponent = [FreezableComponent getFrom:otherEntity];
			
			PhysicsComponent *freezablePhysicsComponent = [PhysicsComponent getFrom:otherEntity];	
			cpBB freezableBB = [freezablePhysicsComponent boundingBox];
			if (cpBBIntersects(freezeBB, freezableBB))
			{
				if (![freezableComponent isFrozen])
				{
					[freezableComponent setIsFrozen:TRUE];
					
					NSDictionary *notificationUserInfo = [NSDictionary dictionaryWithObject:otherEntity forKey:@"entity"];
					[[NSNotificationCenter defaultCenter] postNotificationName:GAME_NOTIFICATION_ENTITY_FROZEN object:self userInfo:notificationUserInfo];
				}
			}
			else
			{
				if ([freezableComponent isFrozen])
				{
					[freezableComponent setIsFrozen:FALSE];
					
					NSDictionary *notificationUserInfo = [NSDictionary dictionaryWithObject:otherEntity forKey:@"entity"];
					[[NSNotificationCenter defaultCenter] postNotificationName:GAME_NOTIFICATION_ENTITY_UNFROZEN object:self userInfo:notificationUserInfo];
				}
			}
		}
	}
}

@end
