//
//  CrumbleComponent.m
//  Beezle
//
//  Created by KM Lagerstrom on 15/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CrumbleComponent.h"

@implementation CrumbleComponent

@synthesize crumbleSoundName = _crumbleSoundName;

-(id) initWithTypeComponentDict:(NSDictionary *)typeComponentDict andInstanceComponentDict:(NSDictionary *)instanceComponentDict world:(World *)world
{
	if (self = [self init])
	{
		// Type
		if ([typeComponentDict objectForKey:@"crumbleSound"] != nil)
		{
			_crumbleSoundName = [[typeComponentDict objectForKey:@"crumbleSound"] copy];
		}
	}
	return self;
}

-(void) dealloc
{
	[_crumbleSoundName release];

	[super dealloc];
}

-(BOOL) hasCrumbleSound
{
	return _crumbleSoundName != nil;
}

@end
