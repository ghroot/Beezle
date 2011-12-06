//
//  BeeaterComponent.m
//  Beezle
//
//  Created by Me on 05/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BeeaterComponent.h"

@implementation BeeaterComponent

@synthesize containedBeeType = _containedBeeType;

-(id) init
{
	if (self = [super init])
	{
		_containedBeeType = BEE_TYPE_NONE;
	}
	return self;
}

-(BOOL) hasContainedBee
{
	return _containedBeeType != BEE_TYPE_NONE;
}

@end