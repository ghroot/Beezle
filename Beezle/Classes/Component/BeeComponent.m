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

-(id) initWithTypeComponentDict:(NSDictionary *)typeComponentDict andInstanceComponentDict:(NSDictionary *)instanceComponentDict world:(World *)world
{
	if (self = [super init])
	{
        // Type
        _type = [BeeType enumFromName:[typeComponentDict objectForKey:@"type"]];
	}
	return self;
}

-(BOOL) killsBeeaters
{
    return [_type beeaterHits] > 0;
}

-(void) resetBeeaterHitsLeft
{
	_beeaterHitsLeft = [_type beeaterHits];
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
	_autoDestroyCountdown = [_type autoDestroyDelay];
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
