//
//  IngameMenuState.m
//  Beezle
//
//  Created by Me on 06/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IngameMenuState.h"
#import "Game.h"
#import "MainMenuState.h"

@implementation IngameMenuState

-(id) init
{
	if (self = [super init])
	{
        [[CCDirector sharedDirector] setNeedClear:TRUE];
        
		CCMenuItem *resumeMenuItem = [CCMenuItemFont itemFromString:@"Resume" target:self selector:@selector(resumeGame:)];
		CCMenuItem *quitMenuItem = [CCMenuItemFont itemFromString:@"Quit" target:self selector:@selector(gotoMainMenu:)];
		_menu = [CCMenu menuWithItems: resumeMenuItem, quitMenuItem, nil];
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

-(void) gotoMainMenu:(id)sender
{
	// This assumes the previous state was the game play state
	[_game popAndReplaceState:[MainMenuState state]];
}

@end
