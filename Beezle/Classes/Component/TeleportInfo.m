//
//  TeleportInfo.m
//  Beezle
//
//  Created by Marcus Lagerstrom on 08/05/12.
//Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TeleportInfo.h"

static const int TELEPORT_DURATION = 20;

@implementation TeleportInfo

@synthesize entity = _entity;

-(id) initWithEntity:(Entity *)entity
{
	if (self = [super init])
	{
		_entity = [entity retain];
		_countdown = TELEPORT_DURATION;
	}
	return self;
}

-(void) dealloc
{
	[_entity release];

	[super dealloc];
}

-(BOOL) hasCountdownReachedZero
{
	return _countdown <= 0;
}

-(void) decreaseCountdown
{
	_countdown--;
}

@end
