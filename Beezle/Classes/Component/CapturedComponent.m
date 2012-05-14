//
//  FrozenComponent.m
//  Beezle
//
//  Created by KM Lagerstrom on 08/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CapturedComponent.h"
#import "BeeType.h"

@implementation CapturedComponent

@synthesize containedBeeType = _containedBeeType;

-(id) init
{
	if (self = [super init])
	{
		_name = @"captured";
	}
	return self;
}

-(id) initWithTypeComponentDict:(NSDictionary *)typeComponentDict andInstanceComponentDict:(NSDictionary *)instanceComponentDict world:(World *)world
{
	if (self = [self init])
	{
        // Type
        NSString *containedBeeTypeAsString = [typeComponentDict objectForKey:@"containedBeeType"];
        _containedBeeType = [BeeType enumFromName:containedBeeTypeAsString];
	}
	return self;
}

@end
