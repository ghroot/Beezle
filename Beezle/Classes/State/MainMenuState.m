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

-(id) init
{
    if (self = [super init])
    {   
        [[CCDirector sharedDirector] setNeedClear:TRUE];
        
        CCMenuItem *play1MenuItem = [CCMenuItemFont itemFromString:@"Play A5" target:self selector:@selector(startGameA5:)];
        CCMenuItem *play2MenuItem = [CCMenuItemFont itemFromString:@"Play A9" target:self selector:@selector(startGameA9:)];
        CCMenuItem *testMenuItem = [CCMenuItemFont itemFromString:@"Test" target:self selector:@selector(startTest:)];
        _menu = [CCMenu menuWithItems: play1MenuItem, play2MenuItem, testMenuItem, nil];
        [_menu alignItemsVerticallyWithPadding:20.0f];
        
        [self addChild:_menu];
    }
    return self;
}

-(void) startGameA5:(id)sender
{
	[_game replaceState:[GameplayState stateWithLevelName:@"Level-A5"]];
}

-(void) startGameA9:(id)sender
{
	[_game replaceState:[GameplayState stateWithLevelName:@"Level-A9"]];
}

-(void) startTest:(id)sender
{
	[_game replaceState:[TestState state]];
}

@end
