//
//  BeeaterAnimationSystem.m
//  Beezle
//
//  Created by KM Lagerstrom on 09/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BeeaterAnimationSystem.h"
#import "BeeaterComponent.h"
#import "EntityUtil.h"
#import "NotificationTypes.h"

@interface BeeaterAnimationSystem()

-(void) addNotificationObservers;
-(void) queueNotification:(NSNotification *)notification;
-(void) handleNotification:(NSNotification *)notification;
-(void) handleBeeaterBeeChanged:(NSNotification *)notification;

@end

@implementation BeeaterAnimationSystem

-(id) init
{
	if (self = [super init])
	{
		_notifications = [[NSMutableArray alloc] init];
		[self addNotificationObservers];
	}
	return self;
}

-(void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[_notifications release];
	
	[super dealloc];
}

-(void) addNotificationObservers
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queueNotification:) name:GAME_NOTIFICATION_BEEATER_CONTAINED_BEE_CHANGED object:nil];
}

-(void) queueNotification:(NSNotification *)notification
{
	[_notifications addObject:notification];
}

-(void) begin
{
	while ([_notifications count] > 0)
	{
		NSNotification *nextNotification = [[_notifications objectAtIndex:0] retain];
		[_notifications removeObjectAtIndex:0];
		[self handleNotification:nextNotification];
		[nextNotification release];
	}
}

-(void) handleNotification:(NSNotification *)notification
{
	if ([[notification name] isEqualToString:GAME_NOTIFICATION_BEEATER_CONTAINED_BEE_CHANGED])
	{
		[self handleBeeaterBeeChanged:notification];
	}
}

-(void) handleBeeaterBeeChanged:(NSNotification *)notification
{
	BeeaterComponent *beeaterComponent = [notification object];
	Entity *beeaterEntity = [beeaterComponent parentEntity];
	[EntityUtil animateBeeaterHeadBasedOnContainedBeeType:beeaterEntity];
}

@end
