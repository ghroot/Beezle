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
@synthesize explodeAnimationName = _explodeAnimationName;

+(ExplodeComponent *) componentWithContentsOfDictionary:(NSDictionary *)dict world:(World *)world
{
	return [[[self alloc] initWithContentsOfDictionary:dict world:world] autorelease];
}

-(id) init
{
	if (self = [super init])
	{
		_name = @"explode";
		_explodeAnimationName = nil;
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
		if ([dict objectForKey:@"explodeAnimation"] != nil)
		{
			_explodeAnimationName = [[dict objectForKey:@"explodeAnimation"] retain];
		}
	}
	return self;
}

-(void) dealloc
{
	[_explodeAnimationName release];
	
	[super dealloc];
}

@end
