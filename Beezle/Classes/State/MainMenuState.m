//
//  MainMenuState.m
//  Beezle
//
//  Created by Me on 24/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MainMenuState.h"
#import "Game.h"
#import "GameplayState.h"
#import "TestState.h"

@implementation MainMenuState

-(void) initialise
{
    CCMenuItem *playMenuItem = [CCMenuItemFont itemFromString:@"Play" target:self selector:@selector(startGame:)];
    CCMenuItem *testMenuItem = [CCMenuItemFont itemFromString:@"Test" target:self selector:@selector(startTest:)];
    _menu = [CCMenu menuWithItems: playMenuItem, testMenuItem, nil];
    [_menu alignItemsVerticallyWithPadding:30.0f];
    
    [self addChild:_menu];
}

-(void) startGame:(id)sender
{
	GameplayState *gameplayState = [[[GameplayState alloc] init] autorelease];
	[_game replaceState:gameplayState];
}

-(void) startTest:(id)sender
{
	TestState *testState = [[[TestState alloc] init] autorelease];
	[_game replaceState:testState];
}

@end
