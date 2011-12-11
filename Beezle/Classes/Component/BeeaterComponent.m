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
@synthesize isKilled = _isKilled;

-(id) init
{
	if (self = [super init])
	{
		_containedBeeType = nil;
        _isKilled = FALSE;
	}
	return self;
}

-(BOOL) hasContainedBee
{
	return _containedBeeType != nil;
}

@end
