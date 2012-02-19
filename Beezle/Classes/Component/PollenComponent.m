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

-(id) initWithContentsOfDictionary:(NSDictionary *)dict world:(World *)world
{
	if (self = [self init])
	{
		if ([dict objectForKey:@"pollenCount"] != nil)
		{
			_pollenCount = [[dict objectForKey:@"pollenCount"] intValue];
		}
	}
	return self;
}

@end
