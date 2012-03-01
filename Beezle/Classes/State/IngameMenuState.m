//
//  IngameMenuState.m
//  Beezle
//
//  Created by Me on 06/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IngameMenuState.h"
#import "EditState.h"
#import "Game.h"
#import "GameplayState.h"
#import "MainMenuState.h"

@implementation IngameMenuState

-(id) init
{
	if (self = [super init])
	{
        [[CCDirector sharedDirector] setNeedClear:TRUE];
        
		_menu = [CCMenu menuWithItems:nil];
		
		CCMenuItem *resumeMenuItem = [CCMenuItemFont itemWithString:@"Resume" target:self selector:@selector(resumeGame:)];
		[_menu addChild:resumeMenuItem];
		CCMenuItem *restartMenuItem = [CCMenuItemFont itemWithString:@"Restart" target:self selector:@selector(restartGame:)];
		[_menu addChild:restartMenuItem];
		if (CONFIG_CAN_EDIT_LEVELS)
		{
			CCMenuItem *editMenuItem = [CCMenuItemFont itemWithString:@"Edit" target:self selector:@selector(editGame:)];
			[_menu addChild:editMenuItem];
		}
		CCMenuItem *quitMenuItem = [CCMenuItemFont itemWithString:@"Quit" target:self selector:@selector(gotoMainMenu:)];
		[_menu addChild:quitMenuItem];
		
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

-(void) editGame:(id)sender
{
	// This assumes the previous state was the game play state
	[_game popState];
	GameplayState *gameplayState = (GameplayState *)[_game currentState];
	[_game replaceState:[EditState stateWithLevelName:[gameplayState levelName]]];
}

-(void) gotoMainMenu:(id)sender
{
	// This assumes the previous state was the game play state
	[_game popAndReplaceState:[MainMenuState state]];
}

@end
