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
@synthesize offset = _offset;
@synthesize autoDestroy = _autoDestroy;
@synthesize interval = _interval;
@synthesize intervalRandomDeviation = _intervalRandomDeviation;
@synthesize countdown = _countdown;

-(id) init
{
    if (self = [super init])
    {
		_countdown = 0.0f;
    }
    return self;
}

-(id) initWithTypeComponentDict:(NSDictionary *)typeComponentDict andInstanceComponentDict:(NSDictionary *)instanceComponentDict world:(World *)world
{
	if (self = [super init])
	{
        // Type
        _entityType = [[typeComponentDict objectForKey:@"entityType"] retain];
		if ([typeComponentDict objectForKey:@"offset"] != nil)
		{
			_offset = [Utils stringToPoint:[typeComponentDict objectForKey:@"offset"]];
		}
        else
        {
            _offset = CGPointZero;
        }
		if ([typeComponentDict objectForKey:@"autoDestroy"] != nil)
		{
			_autoDestroy = [[typeComponentDict objectForKey:@"autoDestroy"] boolValue];
		}
        _interval = [[typeComponentDict objectForKey:@"interval"] floatValue];
		if ([typeComponentDict objectForKey:@"intervalRandomDeviation"] != nil)
		{
			_intervalRandomDeviation = [[typeComponentDict objectForKey:@"intervalRandomDeviation"] floatValue];
		}
	}
	return self;
}

-(void) dealloc
{
	[_entityType release];
	
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
