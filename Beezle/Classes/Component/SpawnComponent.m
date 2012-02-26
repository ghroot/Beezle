//
//  SpawnComponent.m
//  Beezle
//
//  Created by KM Lagerstrom on 10/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SpawnComponent.h"
#import "Utils.h"

@implementation SpawnComponent

@synthesize entityType = _entityType;
@synthesize animationName = _animationName;
@synthesize offset = _offset;
@synthesize autoDestroy = _autoDestroy;
@synthesize interval = _interval;
@synthesize intervalRandomDeviation = _intervalRandomDeviation;
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
		if ([dict objectForKey:@"offset"] != nil)
		{
			_offset = [Utils stringToPoint:[dict objectForKey:@"offset"]];
		}
		if ([dict objectForKey:@"autoDestroy"] != nil)
		{
			_autoDestroy = [[dict objectForKey:@"autoDestroy"] boolValue];
		}
		if ([dict objectForKey:@"interval"] != nil)
		{
			_interval = [[dict objectForKey:@"interval"] floatValue];
		}
		if ([dict objectForKey:@"intervalRandomDeviation"] != nil)
		{
			_intervalRandomDeviation = [[dict objectForKey:@"intervalRandomDeviation"] floatValue];
		}
	}
	return self;
}

-(id) init
{
    if (self = [super init])
    {
		_name = @"spawn";
		_offset = CGPointZero;
		_interval = 1.0f;
		_intervalRandomDeviation = 0.0f;
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
	_countdown = _interval + CCRANDOM_MINUS1_1() * _intervalRandomDeviation;
}

-(void) decreaseAutoDestroyCountdown:(float)time
{
	_countdown -= time;
}

-(BOOL) didAutoDestroyCountdownReachZero
{
	return _countdown <= 0;
}

@end
