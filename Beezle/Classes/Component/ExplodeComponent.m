//
//  ExplodeComponent.m
//  Beezle
//
//  Created by KM Lagerstrom on 15/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ExplodeComponent.h"

@implementation ExplodeComponent

@synthesize radius = _radius;
@synthesize explodeStartAnimationName = _explodeStartAnimationName;
@synthesize explodeEndAnimationName = _explodeEndAnimationName;
@synthesize explosionState = _explosionState;

-(id) init
{
	if (self = [super init])
	{
		_name = @"explode";
        _explosionState = NOT_EXPLODED;
	}
	return self;
}

-(id) initWithTypeComponentDict:(NSDictionary *)typeComponentDict andInstanceComponentDict:(NSDictionary *)instanceComponentDict world:(World *)world
{
	if (self = [self init])
	{
        // Type
        _radius = [[typeComponentDict objectForKey:@"radius"] intValue];
        _explodeStartAnimationName = [[typeComponentDict objectForKey:@"explodeStartAnimation"] copy];
        _explodeEndAnimationName = [[typeComponentDict objectForKey:@"explodeEndAnimation"] copy];
	}
	return self;
}

-(void) dealloc
{
	[_explodeStartAnimationName release];
	[_explodeEndAnimationName release];
	
	[super dealloc];
}

@end
