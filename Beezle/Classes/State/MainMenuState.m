//
//  MainMenuState.m
//  Beezle
//
//  Created by Me on 24/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MainMenuState.h"
#import "EmptyState.h"
#import "Game.h"
#import "GameplayState.h"
#import "TestState.h"

@implementation MainMenuState

-(id) init
{
    if (self = [super init])
    {   
        [[CCDirector sharedDirector] setNeedClear:TRUE];
        
        _menu = [CCMenu menuWithItems: nil];
        
        NSArray *levelNames = [NSArray arrayWithObjects:
                               @"Level-A1",
                               @"Level-A2",
                               @"Level-A5",
                               @"Level-A9",
                               nil];
        for (NSString *levelName in levelNames)
        {
            CCMenuItem *levelMenuItem = [CCMenuItemFont itemFromString:[NSString stringWithFormat:@"Play %@", levelName] target:self selector:@selector(startGame:)];
            [levelMenuItem setUserData:levelName];
            [_menu addChild:levelMenuItem];
        }
        CCMenuItem *testMenuItem = [CCMenuItemFont itemFromString:@"Test" target:self selector:@selector(startTest:)];
        [_menu addChild:testMenuItem];
        
        [_menu alignItemsVerticallyWithPadding:20.0f];
        
        [self addChild:_menu];
    }
    return self;
}

-(void) startGame:(id)sender
{
    NSString *levelName = (NSString *)[sender userData];
	[_game replaceState:[GameplayState stateWithLevelName:levelName]];
}

-(void) startTest:(id)sender
{
	[_game replaceState:[TestState state]];
}

@end
