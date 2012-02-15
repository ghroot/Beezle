//
//  CrumbleComponent.m
//  Beezle
//
//  Created by KM Lagerstrom on 15/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CrumbleComponent.h"

@implementation CrumbleComponent

@synthesize crumbleAnimationName = _crumbleAnimationName;

+(CrumbleComponent *) componentWithContentsOfDictionary:(NSDictionary *)dict world:(World *)world
{
	return [[[self alloc] initWithContentsOfDictionary:dict world:world] autorelease];
}

-(id) init
{
	if (self = [super init])
	{
		_name = @"crumble";
		_crumbleAnimationName = nil;
	}
	return self;
}

-(id) initWithContentsOfDictionary:(NSDictionary *)dict world:(World *)world
{
	if (self = [self init])
	{
		if ([dict objectForKey:@"crumbleAnimation"] != nil)
		{
			_crumbleAnimationName = [[dict objectForKey:@"crumbleAnimation"] retain];
		}
	}
	return self;
}

-(void) dealloc
{
	[_crumbleAnimationName release];
	
	[super dealloc];
}

@end
