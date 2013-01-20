//
//  DestroyComponent.m
//  Beezle
//
//  Created by Marcus Lagerstrom on 01/03/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "DestroyComponent.h"

@implementation DestroyComponent

@synthesize maxVelocity = _maxVelocity;
@synthesize minDuration = _minDuration;
@synthesize currentDuration = _currentDuration;

-(id) initWithTypeComponentDict:(NSDictionary *)typeComponentDict andInstanceComponentDict:(NSDictionary *)instanceComponentDict world:(World *)world
{
	if (self = [super init])
	{
		// Type
		_maxVelocity = [[typeComponentDict objectForKey:@"maxVelocity"] floatValue];
		_minDuration = [[typeComponentDict objectForKey:@"minDuration"] floatValue];
	}
	return self;
}

-(void) resetCurrentDuration
{
	_currentDuration = 0.0f;
}

-(void) increaseCurrentDuration:(float)delta
{
	_currentDuration += delta;
}

@end
