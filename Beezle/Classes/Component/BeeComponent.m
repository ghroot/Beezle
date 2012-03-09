//
//  BeeComponent.m
//  Beezle
//
//  Created by Me on 02/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BeeComponent.h"

@implementation BeeComponent

@synthesize type = _type;

-(id) init
{
	if (self = [super init])
	{
		_name = @"bee";
	}
	return self;
}

-(id) initWithContentsOfDictionary:(NSDictionary *)dict world:(World *)world
{
	if (self = [self init])
	{
		if ([dict objectForKey:@"type"] != nil)
		{
			_type = [BeeType enumFromName:[dict objectForKey:@"type"]];
		}
		if ([dict objectForKey:@"beeaterHits"] != nil)
		{
			_beeaterHits = [[dict objectForKey:@"beeaterHits"] intValue];
			_beeaterHitsLeft = _beeaterHits;
		}
		if ([dict objectForKey:@"autoDestroyDelay"] != nil)
		{
			_autoDestroyDelay = [[dict objectForKey:@"autoDestroyDelay"] intValue] * 1000;
		}
	}
	return self;
}

-(void) decreaseBeeaterHitsLeft
{
	_beeaterHitsLeft--;
}

-(BOOL) isOutOfBeeaterKills
{
	return _beeaterHitsLeft == 0;
}

-(void) resetAutoDestroyCountdown
{
	_autoDestroyCountdown = _autoDestroyDelay;
}

-(void) decreaseAutoDestroyCountdown:(float)time
{
	_autoDestroyCountdown -= time;
}

-(BOOL) didAutoDestroyCountdownReachZero
{
	return _autoDestroyCountdown <= 0;
}

@end
