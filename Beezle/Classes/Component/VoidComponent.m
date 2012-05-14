//
//  VoidComponent.m
//  Beezle
//
//  Created by Marcus on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VoidComponent.h"

@implementation VoidComponent

@synthesize instant = _instant;

-(id) init
{
    if (self = [super init])
    {
		_name = @"void";
    }
    return self;
}

-(id) initWithTypeComponentDict:(NSDictionary *)typeComponentDict andInstanceComponentDict:(NSDictionary *)instanceComponentDict world:(World *)world
{
	if (self = [self init])
	{
        // Type
		if ([typeComponentDict objectForKey:@"instant"] != nil)
		{
			_instant = [[typeComponentDict objectForKey:@"instant"] boolValue];
		}
	}
	return self;
}

@end
