//
//  Beezle.m
//  Beezle
//
//  Created by Me on 23/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Beezle.h"
#import "GameplayState.h"

typedef enum {
	STATE_MENU,
	STATE_GAMEPLAY
} gameStates;

@implementation Beezle

-(void) initialiseStatesListWithContainer:(GameContainer *)container
{
	[self addState:[[[GameplayState alloc] initWithId:STATE_GAMEPLAY] autorelease]];
}

@end
