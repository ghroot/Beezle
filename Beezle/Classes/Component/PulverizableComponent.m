//
//  PulverizableComponent.m
//  Beezle
//
//  Created by Marcus Lagerstrom on 06/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PulverizableComponent.h"

@implementation PulverizableComponent

-(id) init
{
	if (self = [super init])
	{
		_pulverAnimationNamesByRenderSpriteName = [NSMutableDictionary new];
	}
	return self;
}

-(id) initWithTypeComponentDict:(NSDictionary *)typeComponentDict andInstanceComponentDict:(NSDictionary *)instanceComponentDict world:(World *)world
{
	if (self = [self init])
	{
		// Type
		_pulverAnimationNamesByRenderSpriteName = [[NSDictionary alloc] initWithDictionary:[typeComponentDict objectForKey:@"pulverAnimations"]];
	}
	return self;
}

-(void) dealloc
{
	[_pulverAnimationNamesByRenderSpriteName release];

	[super dealloc];
}

-(NSString *) pulverAnimationForRenderSpriteName:(NSString *)renderSpriteName
{
	return [_pulverAnimationNamesByRenderSpriteName objectForKey:renderSpriteName];
}

@end
