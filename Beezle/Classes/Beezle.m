//
//  Beezle.m
//  Beezle
//
//  Created by Me on 23/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Beezle.h"
#import "GameplayState.h"
#import "MenuState.h"
#import "TestState.h"

@implementation Beezle

-(void) initialiseStatesListWithContainer:(GameContainer *)container
{
    [self addState:[[[MenuState alloc] initWithId:STATE_MENU] autorelease]];
    [self addState:[[[TestState alloc] initWithId:STATE_TEST] autorelease]];
	[self addState:[[[GameplayState alloc] initWithId:STATE_GAMEPLAY] autorelease]];
}

@end
