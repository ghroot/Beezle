//
//  PulverizableComponent.m
//  Beezle
//
//  Created by Marcus Lagerstrom on 06/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PulverizableComponent.h"

@implementation PulverizableComponent

@synthesize pulverSoundName = _pulverSoundName;

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
	if (self = [super init])
	{
		// Type
		_pulverAnimationNamesByRenderSpriteName = [[NSDictionary alloc] initWithDictionary:[typeComponentDict objectForKey:@"pulverAnimations"]];
		if ([typeComponentDict objectForKey:@"pulverSound"] != nil)
		{
			_pulverSoundName = [[typeComponentDict objectForKey:@"pulverSound"] copy];
		}
	}
	return self;
}

-(void) dealloc
{
	[_pulverAnimationNamesByRenderSpriteName release];
	[_pulverSoundName release];

	[super dealloc];
}

-(NSString *) pulverAnimationForRenderSpriteName:(NSString *)renderSpriteName
{
	return [_pulverAnimationNamesByRenderSpriteName objectForKey:renderSpriteName];
}

@end
