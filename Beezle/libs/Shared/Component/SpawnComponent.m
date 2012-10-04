//
//  SpawnComponent.m
//  Beezle
//
//  Created by KM Lagerstrom on 10/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SpawnComponent.h"

@implementation SpawnComponent

@synthesize entityType = _entityType;
@synthesize offset = _offset;
@synthesize autoDestroy = _autoDestroy;
@synthesize interval = _interval;
@synthesize intervalRandomDeviation = _intervalRandomDeviation;
@synthesize spawnWhenDestroyed = _spawnWhenDestroyed;
@synthesize keepRotation = _keepRotation;
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
			_offset = CGPointFromString([typeComponentDict objectForKey:@"offset"]);
		}
        else
        {
            _offset = CGPointZero;
        }
		if ([typeComponentDict objectForKey:@"autoDestroy"] != nil)
		{
			_autoDestroy = [[typeComponentDict objectForKey:@"autoDestroy"] boolValue];
		}
		if ([typeComponentDict objectForKey:@"interval"] != nil)
		{
        	_interval = [[typeComponentDict objectForKey:@"interval"] floatValue];
		}
		if ([typeComponentDict objectForKey:@"intervalRandomDeviation"] != nil)
		{
			_intervalRandomDeviation = [[typeComponentDict objectForKey:@"intervalRandomDeviation"] floatValue];
		}
		if ([typeComponentDict objectForKey:@"spawnWhenDestroyed"] != nil)
		{
			_spawnWhenDestroyed = [[typeComponentDict objectForKey:@"spawnWhenDestroyed"] boolValue];
		}
		if ([typeComponentDict objectForKey:@"keepRotation"] != nil)
		{
			_keepRotation = [[typeComponentDict objectForKey:@"keepRotation"] boolValue];
		}
	}
	return self;
}

-(void) dealloc
{
	[_entityType release];
	
	[super dealloc];
}

-(BOOL) hasCountdown
{
	return _interval > 0;
}

-(void) resetCountdown
{
	_countdown = _interval + CCRANDOM_MINUS1_1() * _intervalRandomDeviation;
}

-(void) decreaseCountdown:(float)time
{
	_countdown -= time;
}

-(BOOL) didCountdownReachZero
{
	return _countdown <= 0;
}

@end
