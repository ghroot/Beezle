//
//  Beezle.m
//  Beezle
//
//  Created by Me on 23/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Beezle.h"

typedef enum {
	STATE_MENU,
	STATE_GAMEPLAY
} gameStates;

@implementation Beezle

-(id) init
{
	if (self = [super init])
	{
		[self addState:[[GameplayState alloc] initWithId:STATE_GAMEPLAY]];
		[self enterState:STATE_GAMEPLAY];
	}
	return self;
}

@end
