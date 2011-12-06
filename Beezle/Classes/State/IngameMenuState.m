//
//  IngameMenuState.m
//  Beezle
//
//  Created by Me on 06/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IngameMenuState.h"
#import "CocosGameContainer.h"
#import "CocosStateBasedGame.h"

@implementation IngameMenuState

-(void) initialise
{
    CCMenuItem *resumeMenuItem = [CCMenuItemFont itemFromString:@"Resume" target:self selector:@selector(resumeGame:)];
	CCMenuItem *quitMenuItem = [CCMenuItemFont itemFromString:@"Quit" target:self selector:@selector(gotoMainMenu:)];
    _menu = [CCMenu menuWithItems: resumeMenuItem, quitMenuItem, nil];
	[_menu alignItemsVerticallyWithPadding:30.0f];
    
    [_layer addChild:_menu];
}

-(void) resumeGame:(id)sender
{
	// This assumes the previous state was the game play state
	CocosStateBasedGame *cocosStateBasedGame = (CocosStateBasedGame *)[self game];
	[cocosStateBasedGame enterPreviousState];
}

-(void) gotoMainMenu:(id)sender
{
	// This assumes the previous state was the game play state
	CocosStateBasedGame *cocosStateBasedGame = (CocosStateBasedGame *)[self game];
	[cocosStateBasedGame enterStateDiscardPrevious:STATE_MAIN_MENU];
}

@end
