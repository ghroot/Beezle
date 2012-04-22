//
//  BeeWithGateCollisionHandler.m
//  Beezle
//
//  Created by KM Lagerstrom on 22/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BeeWithGateCollisionHandler.h"
#import "BeeComponent.h"
#import "GateComponent.h"
#import "LevelSession.h"
#import "NotificationTypes.h"

@implementation BeeWithGateCollisionHandler

-(id) initWithWorld:(World *)world levelSession:(LevelSession *)levelSession
{
	if (self = [super initWithWorld:world levelSession:levelSession])
	{
		[_firstComponentClasses addObject:[BeeComponent class]];
		[_secondComponentClasses addObject:[GateComponent class]];
	}
	return self;
}

-(BOOL) handleCollisionBetween:(Entity *)firstEntity and:(Entity *)secondEntity collision:(Collision *)collision
{
	Entity *gateEntity = secondEntity;
	GateComponent *gateComponent = [GateComponent getFrom:gateEntity];
	if ([gateComponent isOpened])
	{
		[_levelSession setDidUseKey:TRUE];
		
		// Game notification
		[[NSNotificationCenter defaultCenter] postNotificationName:GAME_NOTIFICATION_GATE_ENTERED object:self userInfo:nil];
	}
	return FALSE;
}

@end
