//
//  NotificationProcessor.m
//  Beezle
//
//  Created by KM Lagerstrom on 14/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NotificationProcessor.h"

@interface NotificationProcessor()

-(void) queueNotification:(NSNotification *)notification;
-(void) processNotification:(NSNotification *)notification;

@end

@implementation NotificationProcessor

// Designated initializer
-(id) initWithTarget:(id)target
{
	if (self = [super init])
	{
		_target = target;
		_notifications = [NSMutableArray new];
        _selectorsByNotificationNames = [NSMutableDictionary new];
		_isActive = TRUE;
	}
	return self;
}

-(id) init
{
	self = [self initWithTarget:nil];
	return self;
}

-(void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[_notifications release];
    [_selectorsByNotificationNames release];
	
	[super dealloc];
}

-(void) registerNotification:(NSString *)name withSelector:(SEL)selector
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queueNotification:) name:name object:nil];
    [_selectorsByNotificationNames setObject:NSStringFromSelector(selector) forKey:name];
}

-(void) queueNotification:(NSNotification *)notification
{
	if (_isActive)
	{
		[_notifications addObject:notification];
	}
}

-(void) processNotifications
{
	while ([_notifications count] > 0)
	{
		NSNotification *nextNotification = [[_notifications objectAtIndex:0] retain];
		[_notifications removeObjectAtIndex:0];
		[self processNotification:nextNotification];
		[nextNotification release];
	}
}

-(void) processNotification:(NSNotification *)notification
{
//	NSLog(@"Processing notification %@ in %@", [notification name], _target);
	
    SEL selector = NSSelectorFromString([_selectorsByNotificationNames objectForKey:[notification name]]);
    [_target performSelector:selector withObject:notification];
}

-(void) activate
{
	_isActive = TRUE;
}

-(void) deactivate
{
	[_notifications removeAllObjects];
	_isActive = FALSE;
}

@end
