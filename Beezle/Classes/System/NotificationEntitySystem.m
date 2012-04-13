//
//  NotificationEntitySystem.m
//  Beezle
//
//  Created by Marcus on 4/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NotificationEntitySystem.h"

@interface NotificationEntitySystem()

-(void) queueNotification:(NSNotification *)notification;
-(void) handleNotification:(NSNotification *)notification;

@end

@implementation NotificationEntitySystem

-(id) init
{
	if (self = [super init])
	{
		_notifications = [NSMutableArray new];
        _selectorsByNotificationNames = [NSMutableDictionary new];
	}
	return self;
}

-(void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[_notifications release];
    [_selectorsByNotificationNames release];
	
	[super dealloc];
}

-(void) addNotificationObserver:(NSString *)name selector:(SEL)selector
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queueNotification:) name:name object:nil];
    [_selectorsByNotificationNames setObject:NSStringFromSelector(selector) forKey:name];
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
    SEL selector = NSSelectorFromString([_selectorsByNotificationNames objectForKey:[notification name]]);
    [self performSelector:selector withObject:notification];
}

@end
