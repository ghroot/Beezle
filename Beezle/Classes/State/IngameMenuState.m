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
#import "LevelOrganizer.h"
#import "MainMenuState.h"

@interface IngameMenuState()

-(void) resumeGame:(id)sender;
-(void) restartGame:(id)sender;
-(void) editGame:(id)sender;
-(void) nextLevel:(id)sender;
-(void) gotoMainMenu:(id)sender;

@end

@implementation IngameMenuState

-(void) initialise
{
	[super initialise];
	
	_menu = [CCMenu menuWithItems:nil];
	
	CCMenuItem *resumeMenuItem = [CCMenuItemFont itemWithString:@"Resume" target:self selector:@selector(resumeGame:)];
	[_menu addChild:resumeMenuItem];
	CCMenuItem *restartMenuItem = [CCMenuItemFont itemWithString:@"Restart" target:self selector:@selector(restartGame:)];
	[_menu addChild:restartMenuItem];
	if (CONFIG_CAN_EDIT_LEVELS)
	{
		CCMenuItem *editMenuItem = [CCMenuItemFont itemWithString:@"Edit" target:self selector:@selector(editGame:)];
		[_menu addChild:editMenuItem];
		CCMenuItem *nextLevelMenuItem = [CCMenuItemFont itemWithString:@"Next level" target:self selector:@selector(nextLevel:)];
		[_menu addChild:nextLevelMenuItem];
	}
	CCMenuItem *quitMenuItem = [CCMenuItemFont itemWithString:@"Quit" target:self selector:@selector(gotoMainMenu:)];
	[_menu addChild:quitMenuItem];
	
	[_menu alignItemsVerticallyWithPadding:30.0f];
	
	[self addChild:_menu];
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

-(void) nextLevel:(id)sender
{
	// This assumes the previous state was the game play state
	[_game popState];
	GameplayState *gameplayState = (GameplayState *)[_game currentState];
	NSString *nextLevelName = [[LevelOrganizer sharedOrganizer] levelNameAfter:[gameplayState levelName]];
    if (nextLevelName != nil)
    {
        [_game replaceState:[GameplayState stateWithLevelName:nextLevelName]];
    }
    else
    {
		[_game replaceState:[MainMenuState state]];
    }
}

-(void) gotoMainMenu:(id)sender
{
	[_game clearAndReplaceState:[MainMenuState state]];
}

@end
