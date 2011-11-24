//
//  Beezle.m
//  Beezle
//
//  Created by Me on 23/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Beezle.h"
#import "GameplayState.h"
#import "TestState.h"

typedef enum {
	STATE_MENU,
	STATE_GAMEPLAY,
    STATE_TEST,
} gameStates;

@implementation Beezle

-(void) initialiseStatesListWithContainer:(GameContainer *)container
{
//    [self addState:[[[TestState alloc] initWithId:STATE_TEST] autorelease]];
	[self addState:[[[GameplayState alloc] initWithId:STATE_GAMEPLAY] autorelease]];
}

@end
