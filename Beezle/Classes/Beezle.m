//
//  Beezle.m
//  Beezle
//
//  Created by Me on 23/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Beezle.h"
#import "GameplayState.h"
#import "MainMenuState.h"
#import "TestState.h"

@implementation Beezle

-(void) initialiseStatesListWithContainer:(GameContainer *)container
{
    [self addState:[[[MainMenuState alloc] initWithId:STATE_MAIN_MENU] autorelease]];
    [self addState:[[[TestState alloc] initWithId:STATE_TEST] autorelease]];
	[self addState:[[[GameplayState alloc] initWithId:STATE_GAMEPLAY] autorelease]];
}

@end
