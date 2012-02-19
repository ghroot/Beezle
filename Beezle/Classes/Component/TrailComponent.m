//
//  TrailComponent.m
//  Beezle
//
//  Created by KM Lagerstrom on 10/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TrailComponent.h"

@implementation TrailComponent

@synthesize entityType = _entityType;
@synthesize animationName = _animationName;
@synthesize interval = _interval;
@synthesize countdown = _countdown;

-(id) initWithContentsOfDictionary:(NSDictionary *)dict world:(World *)world
{
	if (self = [self init])
	{
		if ([dict objectForKey:@"entityType"] != nil)
		{
			_entityType = [[dict objectForKey:@"entityType"] retain];
		}
		if ([dict objectForKey:@"animationName"] != nil)
		{
			_animationName = [[dict objectForKey:@"animationName"] retain];
		}
		if ([dict objectForKey:@"interval"] != nil)
		{
			_interval = [[dict objectForKey:@"interval"] floatValue];
		}
	}
	return self;
}

-(id) init
{
    if (self = [super init])
    {
		_name = @"trail";
		_entityType = @"";
		_animationName = @"";
		_interval = 1.0f;
		_countdown = 0.0f;
    }
    return self;
}

-(void) dealloc
{
	[_entityType release];
	[_animationName release];
	
	[super dealloc];
}

-(void) resetCountdown
{
	[self setCountdown:[self interval]];
}

@end
