//
//  MainMenuState.m
//  Beezle
//
//  Created by Me on 24/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MainMenuState.h"
#import "Beezle.h"
#import "CocosGameContainer.h"

@implementation MainMenuState

-(void) initialise
{
    CCMenuItem *playMenuItem = [CCMenuItemFont itemFromString:@"Play" target:self selector:@selector(startGame:)];
    CCMenuItem *testMenuItem = [CCMenuItemFont itemFromString:@"Test" target:self selector:@selector(startTest:)];
    _menu = [CCMenu menuWithItems: playMenuItem, testMenuItem, nil];
    [_menu alignItemsVerticallyWithPadding:30.0f];
    
    [_layer addChild:_menu];
}

-(void) startGame:(id)sender
{
	[_game enterState:STATE_GAMEPLAY];
}

-(void) startTest:(id)sender
{
	[_game enterState:STATE_TEST];
}

@end
