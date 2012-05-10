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

-(id) initWithContentsOfDictionary:(NSDictionary *)dict world:(World *)world
{
	if (self = [self init])
	{
		if ([dict objectForKey:@"containedBeeType"] != nil)
		{
			NSString *defaultContainedBeeTypeAsString = [dict objectForKey:@"containedBeeType"];
			BeeType *defaultContainedBeeType = [BeeType enumFromName:defaultContainedBeeTypeAsString];
			_containedBeeType = defaultContainedBeeType;
		}
	}
	return self;
}

-(id) init
{
	if (self = [super init])
	{
		_name = @"captured";
		_containedBeeType = nil;
	}
	return self;
}

@end
