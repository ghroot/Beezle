//
//  DebugNotificationTrackerSystem.m
//  Beezle
//
//  Created by KM Lagerstrom on 15/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DebugNotificationTrackerSystem.h"
#import "NotificationTypes.h"

@interface DebugNotificationTrackerSystem()

-(void) addNotificationObservers;
-(void) printNotification:(NSNotification *)notification;

@end

@implementation DebugNotificationTrackerSystem

-(id) init
{
	if (self = [super init])
	{
		[self addNotificationObservers];
	}
	return self;
}

-(void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[super dealloc];
}

-(void) addNotificationObservers
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(printNotification:) name:GAME_NOTIFICATION_BEE_LOADED object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(printNotification:) name:GAME_NOTIFICATION_BEE_FIRED object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(printNotification:) name:GAME_NOTIFICATION_BEE_SAVED object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(printNotification:) name:GAME_NOTIFICATION_BEEATER_CONTAINED_BEE_CHANGED object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(printNotification:) name:GAME_NOTIFICATION_BEEATER_HIT object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(printNotification:) name:GAME_NOTIFICATION_ENTITY_CRUMBLED object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(printNotification:) name:GAME_NOTIFICATION_GATE_ENTERED object:nil];
}

-(void) printNotification:(NSNotification *)notification
{
	NSLog(@"Notification: %@", [notification name]);
}

@end
