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

-(id) init
{
	if (self = [super init])
	{
		_name = @"pollen";
	}
	return self;
}

-(id) initWithTypeComponentDict:(NSDictionary *)typeComponentDict andInstanceComponentDict:(NSDictionary *)instanceComponentDict world:(World *)world
{
	if (self = [self init])
	{
        // Type
        _pollenCount = [[typeComponentDict objectForKey:@"pollenCount"] intValue];
	}
	return self;
}

@end
