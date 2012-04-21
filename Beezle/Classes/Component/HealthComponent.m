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

-(id) initWithContentsOfDictionary:(NSDictionary *)dict world:(World *)world
{
	if (self = [self init])
	{
		if ([dict objectForKey:@"totalHealthPoints"] != nil)
		{
			_totalHealthPoints = [[dict objectForKey:@"totalHealthPoints"] intValue];
		}
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
