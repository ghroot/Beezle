//
//  HealthComponent.m
//  Beezle
//
//  Created by KM Lagerstrom on 21/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HealthComponent.h"

@implementation HealthComponent

-(id) initWithTypeComponentDict:(NSDictionary *)typeComponentDict andInstanceComponentDict:(NSDictionary *)instanceComponentDict world:(World *)world
{
	if (self = [super init])
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
