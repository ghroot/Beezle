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

@implementation FreezeSystem

-(id) init
{
	self = [super initWithUsedComponentClass:[FreezableComponent class]];
	return self;
}

-(void) initialise
{
	_physicsSystem = (PhysicsSystem *)[[_world systemManager] getSystem:[PhysicsSystem class]];
}

-(void) processEntity:(Entity *)entity
{
	PhysicsComponent *physicsComponent = [PhysicsComponent getFrom:entity];
	
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
			if ([otherEntity hasComponent:[FreezeComponent class]])
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
