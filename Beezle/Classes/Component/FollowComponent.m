//
//  FollowComponent
//  Beezle
//
//  Created by marcus on 01/06/2012.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "FollowComponent.h"

@implementation FollowComponent

@synthesize state = _state;
@synthesize location = _location;

-(id) initWithTypeComponentDict:(NSDictionary *)typeComponentDict andInstanceComponentDict:(NSDictionary *)instanceComponentDict world:(World *)world
{
	self = [super init];
	return self;
}

@end