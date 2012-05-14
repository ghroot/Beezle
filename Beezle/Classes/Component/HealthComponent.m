//
//  HealthComponent.m
//  Beezle
//
//  Created by KM Lagerstrom on 21/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HealthComponent.h"

@implementation HealthComponent

-(id) init
{
    if (self = [super init])
    {
		_name = @"health";
    }
    return self;
}

-(id) initWithTypeComponentDict:(NSDictionary *)typeComponentDict andInstanceComponentDict:(NSDictionary *)instanceComponentDict world:(World *)world
{
	if (self = [self init])
	{
        // Type
        _totalHealthPoints = [[typeComponentDict objectForKey:@"totalHealthPoints"] intValue];
	}
	return self;
}

-(void) resetHealthPointsLeft
{
	_healthPointsLeft = _totalHealthPoints;
}

-(void) deductHealthPoint
{
	_healthPointsLeft--;
}

-(BOOL) hasHealthPointsLeft
{
	return _healthPointsLeft > 0;
}

@end
