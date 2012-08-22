//
//  PollenComponent.m
//  Beezle
//
//  Created by KM Lagerstrom on 19/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PollenComponent.h"

@implementation PollenComponent

@synthesize pollenCount = _pollenCount;
@synthesize pickupLabelOffset = _pickupLabelOffset;

-(id) initWithTypeComponentDict:(NSDictionary *)typeComponentDict andInstanceComponentDict:(NSDictionary *)instanceComponentDict world:(World *)world
{
	if (self = [super init])
	{
        // Type
        _pollenCount = [[typeComponentDict objectForKey:@"pollenCount"] intValue];
		if ([typeComponentDict objectForKey:@"pickupLabelOffset"] != nil)
		{
			_pickupLabelOffset = CGPointFromString([typeComponentDict objectForKey:@"pickupLabelOffset"]);
		}
		else
		{
			_pickupLabelOffset = CGPointZero;
		}
	}
	return self;
}

@end
