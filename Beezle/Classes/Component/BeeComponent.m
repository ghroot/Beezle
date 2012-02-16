//
//  BeeComponent.m
//  Beezle
//
//  Created by Me on 02/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BeeComponent.h"

@implementation BeeComponent

@synthesize type = _type;
@synthesize speedeeHitBeeater = _speedeeHitBeeater;

+(id) componentWithType:(BeeType *)type
{
	return [[[self alloc] initWithType:type] autorelease];
}

+(BeeComponent *) componentWithContentsOfDictionary:(NSDictionary *)dict world:(World *)world
{
	return [[[self alloc] initWithContentsOfDictionary:dict world:world] autorelease];
}

-(id) init
{
	if (self = [super init])
	{
		_name = @"bee";
	}
	return self;
}

-(id) initWithType:(BeeType *)type
{
	if (self = [self init])
	{
		_type = type;
	}
	return self;
}

-(id) initWithContentsOfDictionary:(NSDictionary *)dict world:(World *)world
{
	if (self = [self init])
	{
		if ([dict objectForKey:@"type"] != nil)
		{
			_type = [BeeType enumFromName:[dict objectForKey:@"type"]];
		}
	}
	return self;
}

@end
