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

-(id) initWithTypeComponentDict:(NSDictionary *)typeComponentDict andInstanceComponentDict:(NSDictionary *)instanceComponentDict world:(World *)world
{
	if (self = [self init])
	{
        // Type
		if ([typeComponentDict objectForKey:@"splashEntityType"] != nil)
		{
			_splashEntityType = [[typeComponentDict objectForKey:@"splashEntityType"] copy];
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
