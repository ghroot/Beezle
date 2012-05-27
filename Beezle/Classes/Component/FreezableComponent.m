//
//  FreezableComponent.m
//  Beezle
//
//  Created by KM Lagerstrom on 10/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FreezableComponent.h"

@implementation FreezableComponent

@synthesize deferFreezeHandling = _deferFreezeHandling;
@synthesize isFrozen = _isFrozen;

-(id) initWithTypeComponentDict:(NSDictionary *)typeComponentDict andInstanceComponentDict:(NSDictionary *)instanceComponentDict world:(World *)world
{
	if (self = [super init])
	{
        // Type
		_deferFreezeHandling = [[typeComponentDict objectForKey:@"deferFreezeHandling"] boolValue];
	}
	return self;
}

@end
