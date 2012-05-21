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

@synthesize defaultContainedBeeType = _defaultContainedBeeType;
@synthesize containedBeeType = _containedBeeType;
@synthesize destroyedByBeeType = _destroyedByBeeType;

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
		NSString *defaultContainedBeeTypeAsString = [typeComponentDict objectForKey:@"defaultContainedBeeType"];
		_containedBeeType = [BeeType enumFromName:defaultContainedBeeTypeAsString];
		
        // Instance
		if (instanceComponentDict != nil)
		{
			NSString *containedBeeTypeAsString = [instanceComponentDict objectForKey:@"containedBeeType"];
			_containedBeeType = [BeeType enumFromName:containedBeeTypeAsString];
		}
	}
	return self;
}

-(NSDictionary *) getInstanceComponentDict
{
	NSMutableDictionary *instanceComponentDict = [NSMutableDictionary dictionary];
	[instanceComponentDict setObject:[_containedBeeType name] forKey:@"containedBeeType"];
	return instanceComponentDict;
}

@end
