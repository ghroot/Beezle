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
@synthesize hasExploded = _hasExploded;

-(id) init
{
	if (self = [super init])
	{
		_name = @"explode";
	}
	return self;
}

-(id) initWithContentsOfDictionary:(NSDictionary *)dict world:(World *)world
{
	if (self = [self init])
	{
		if ([dict objectForKey:@"radius"] != nil)
		{
			_radius = [[dict objectForKey:@"radius"] intValue];
		}
		if ([dict objectForKey:@"explodeStartAnimation"] != nil &&
			[dict objectForKey:@"explodeEndAnimation"] != nil)
		{
			_explodeStartAnimationName = [[dict objectForKey:@"explodeStartAnimation"] retain];
			_explodeEndAnimationName = [[dict objectForKey:@"explodeEndAnimation"] retain];
		}
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
