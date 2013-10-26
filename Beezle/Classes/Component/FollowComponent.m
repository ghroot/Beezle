//
//  FollowComponent
//  Beezle
//
//  Created by marcus on 01/06/2012.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "FollowComponent.h"

@implementation FollowComponent

@synthesize alwaysActive = _alwaysActive;
@synthesize locationAnimationFile = _locationAnimationFile;
@synthesize locationAnimationName = _locationAnimationName;
@synthesize state = _state;
@synthesize location = _location;
@synthesize locationEntity = _locationEntity;

-(id) initWithTypeComponentDict:(NSDictionary *)typeComponentDict andInstanceComponentDict:(NSDictionary *)instanceComponentDict world:(World *)world
{
	if (self = [self init])
	{
		// Type
		_alwaysActive = [[typeComponentDict objectForKey:@"alwaysActive"] boolValue];
		_locationAnimationFile = [[typeComponentDict objectForKey:@"locationAnimationFile"] copy];
		_locationAnimationName = [[typeComponentDict objectForKey:@"locationAnimationName"] copy];
	}
	return self;
}

-(void) dealloc
{
	[_locationAnimationFile release];
	[_locationAnimationName release];

	[super dealloc];
}

@end