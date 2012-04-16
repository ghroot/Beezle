//
//  WaterComponent.m
//  Beezle
//
//  Created by KM Lagerstrom on 15/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WaterComponent.h"

@implementation WaterComponent

@synthesize waterType = _waterType;
@synthesize splashAnimationName = _splashAnimationName;

-(id) init
{
	if (self = [super init])
	{
		_name = @"water";
	}
	return self;
}

-(id) initWithContentsOfDictionary:(NSDictionary *)dict world:(World *)world
{
	if (self = [self init])
	{
		if ([dict objectForKey:@"splashAnimation"] != nil)
		{
			_splashAnimationName = [[dict objectForKey:@"splashAnimation"] copy];
		}
	}
	return self;
}

-(void) dealloc
{
	[_splashAnimationName release];
	
	[super dealloc];
}

@end
