//
//  TrajectoryComponent.m
//  Beezle
//
//  Created by Me on 08/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TrajectoryComponent.h"

@implementation TrajectoryComponent

-(id) init
{
	if (self = [super init])
	{
		_startPoint = CGPointZero;
		_power = 0.0f;
		_angle = 0.0f;
	}
	return self;
}

@synthesize startPoint = _startPoint;
@synthesize power = _power;
@synthesize angle = _angle;

-(BOOL) isZero
{
	return _power == 0.0f;
}

-(void) reset
{
	_startPoint = CGPointZero;
	_power = 0.0f;
	_angle = 0.0f;
}

@end
