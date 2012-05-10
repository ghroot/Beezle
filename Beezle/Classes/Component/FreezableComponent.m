//
//  FreezableComponent.m
//  Beezle
//
//  Created by KM Lagerstrom on 10/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FreezableComponent.h"

@implementation FreezableComponent

@synthesize isFrozen = _isFrozen;

-(id) init
{
	if (self = [super init])
	{
		_name = @"freezable";
	}
	return self;
}

@end
