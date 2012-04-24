//
//  MainMenuState.m
//  Beezle
//
//  Created by Me on 24/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MainMenuState.h"
#import "Game.h"
#import "LevelSender.h"
#import "LevelThemeSelectMenuState.h"
#import "PlayerInformation.h"
#import "TestState.h"

@interface MainMenuState()

-(void) selectTheme:(id)sender;
-(void) sendEditedLevels:(id)sender;
-(void) startTest:(id)sender;
-(void) resetPlayerInformation:(id)sender;

@end

@implementation MainMenuState

-(void) initialise
{
	[super initialise];
	
	_menu = [CCMenu menuWithItems:nil];
	
	CCMenuItem *playMenuItem = [CCMenuItemFont itemWithString:@"Play" target:self selector:@selector(selectTheme:)];
	[_menu addChild:playMenuItem];
#ifdef DEBUG
	CCMenuItem *sendMenuItem = [CCMenuItemFont itemWithString:@"Send Edited Levels" target:self selector:@selector(sendEditedLevels:)];
	[_menu addChild:sendMenuItem];
#endif
	CCMenuItem *testMenuItem = [CCMenuItemFont itemWithString:@"Test" target:self selector:@selector(startTest:)];
	[_menu addChild:testMenuItem];
	CCMenuItem *resetMenuItem = [CCMenuItemFont itemWithString:@"Reset player information" target:self selector:@selector(resetPlayerInformation:)];
	[_menu addChild:resetMenuItem];
	
	[_menu alignItemsVerticallyWithPadding:20.0f];
	
	[self addChild:_menu];
}

-(void) selectTheme:(id)sender
{
	[_game pushState:[LevelThemeSelectMenuState state]];
}

-(void) sendEditedLevels:(id)sender
{
	[[LevelSender sharedSender] sendEditedLevels];
}

-(void) startTest:(id)sender
{
	[_game replaceState:[TestState state]];
}

-(void) resetPlayerInformation:(id)sender
{
	[[PlayerInformation sharedInformation] reset];
}

@end
