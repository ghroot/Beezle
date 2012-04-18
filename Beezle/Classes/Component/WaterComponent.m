//
//  WaterComponent.m
//  Beezle
//
//  Created by Marcus on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WaterComponent.h"

@implementation WaterComponent

@synthesize splashEntityType = _splashEntityType;

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
		if ([dict objectForKey:@"splashEntityType"] != nil)
		{
			_splashEntityType = [[dict objectForKey:@"splashEntityType"] copy];
		}
	}
	return self;
}

-(void) dealloc
{
    [_splashEntityType release];
    
    [super dealloc];
}

@end
