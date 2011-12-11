//
//  IngameMenuState.m
//  Beezle
//
//  Created by Me on 06/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IngameMenuState.h"
#import "Game.h"
#import "GameplayState.h"
#import "MainMenuState.h"

@implementation IngameMenuState

-(id) init
{
	if (self = [super init])
	{
        [[CCDirector sharedDirector] setNeedClear:TRUE];
        
		CCMenuItem *resumeMenuItem = [CCMenuItemFont itemFromString:@"Resume" target:self selector:@selector(resumeGame:)];
		CCMenuItem *restartMenuItem = [CCMenuItemFont itemFromString:@"Restart" target:self selector:@selector(restartGame:)];
		CCMenuItem *quitMenuItem = [CCMenuItemFont itemFromString:@"Quit" target:self selector:@selector(gotoMainMenu:)];
		_menu = [CCMenu menuWithItems: resumeMenuItem, restartMenuItem, quitMenuItem, nil];
		[_menu alignItemsVerticallyWithPadding:30.0f];
		
		[self addChild:_menu];
	}
    return self;
}

-(void) resumeGame:(id)sender
{
	// This assumes the previous state was the game play state
	[_game popState];
}

-(void) restartGame:(id)sender
{
	// This assumes the previous state was the game play state
	[_game popState];
	GameplayState *gameplayState = (GameplayState *)[_game currentState];
	[_game replaceState:[GameplayState stateWithLevelName:[gameplayState levelName]]];
}

-(void) gotoMainMenu:(id)sender
{
	// This assumes the previous state was the game play state
	[_game popAndReplaceState:[MainMenuState state]];
}

@end
