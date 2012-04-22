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

-(void) populateWithContentsOfDictionary:(NSDictionary *)dict world:(World *)world
{
	if ([dict objectForKey:@"instant"] != nil)
	{
		_instant = [[dict objectForKey:@"instant"] boolValue];
	}
}

@end
