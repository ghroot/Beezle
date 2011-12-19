//
//  EditIngameMenuState.m
//  Beezle
//
//  Created by Me on 18/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EditIngameMenuState.h"
#import "EditState.h"
#import "Game.h"
#import "GameplayState.h"
#import "LevelLayoutCache.h"
#import "MainMenuState.h"

@implementation EditIngameMenuState

-(id) init
{
	if (self = [super init])
	{
        [[CCDirector sharedDirector] setNeedClear:TRUE];
        
		_menu = [CCMenu menuWithItems:nil];
		
		CCMenuItem *resumeMenuItem = [CCMenuItemFont itemFromString:@"Resume" target:self selector:@selector(resumeGame:)];
		[_menu addChild:resumeMenuItem];
		CCMenuItem *tryMenuItem = [CCMenuItemFont itemFromString:@"Try" target:self selector:@selector(tryGame:)];
		[_menu addChild:tryMenuItem];
		CCMenuItem *resetMenuItem = [CCMenuItemFont itemFromString:@"Reset" target:self selector:@selector(resetGame:)];
		[_menu addChild:resetMenuItem];
		CCMenuItem *quitMenuItem = [CCMenuItemFont itemFromString:@"Quit" target:self selector:@selector(gotoMainMenu:)];
		[_menu addChild:quitMenuItem];
		
		[_menu alignItemsVerticallyWithPadding:30.0f];
		
		[self addChild:_menu];
	}
    return self;
}

-(void) resumeGame:(id)sender
{
	// This assumes the previous state was the edit state
	[_game popState];
}

-(void) tryGame:(id)sender
{
	// This assumes the previous state was the edit state
	[_game popState];
	EditState *editState = (EditState *)[_game currentState];
	
	// Replace cached version of level layout
	[[LevelLayoutCache sharedLevelLayoutCache] addLevelLayoutWithWorld:[editState world] levelName:[editState levelName]];
	
	[_game replaceState:[GameplayState stateWithLevelName:[editState levelName]]];
}

-(void) resetGame:(id)sender
{
	// This assumes the previous state was the edit state
	[_game popState];
	EditState *editState = (EditState *)[_game currentState];
	
	// Remove cached version of level layout
	[[LevelLayoutCache sharedLevelLayoutCache] purgeCachedLevelLayout:[editState levelName]];
	
	[_game replaceState:[EditState stateWithLevelName:[editState levelName]]];
}

-(void) gotoMainMenu:(id)sender
{
	// This assumes the previous state was the edit state
	[_game popAndReplaceState:[MainMenuState state]];
}

@end
