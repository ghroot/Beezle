//
//  LevelThemeSelectMenuState.m
//  Beezle
//
//  Created by KM Lagerstrom on 11/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LevelThemeSelectMenuState.h"
#import "Game.h"
#import "LevelSelectMenuState.h"
#import "LevelThemeSelectMenuItem.h"

@interface LevelThemeSelectMenuState()

-(void) createLevelThemeMenuItems;
-(void) selectLevel:(id)sender;
-(void) goBack:(id)sender;

@end

@implementation LevelThemeSelectMenuState

-(void) initialise
{
	[super initialise];
	
	_menu = [CCMenu menuWithItems:nil];
	
	[self createLevelThemeMenuItems];
	
	CCMenuItemFont *backMenuItem = [CCMenuItemFont itemWithString:@"Back" target:self selector:@selector(goBack:)];
	[backMenuItem setFontSize:24];
	[_menu addChild:backMenuItem];
	
	[_menu alignItemsVertically];
	
	[self addChild:_menu];
}

-(void) createLevelThemeMenuItems
{
	NSArray *themes = [NSArray arrayWithObjects:@"A", @"B", nil];
	for (NSString *theme in themes)
	{
		LevelThemeSelectMenuItem *levelThemeMenuItem = [LevelThemeSelectMenuItem itemWithTheme:theme target:self selector:@selector(selectLevel:)];
		[_menu addChild:levelThemeMenuItem];
	}
}

-(void) selectLevel:(id)sender
{
	LevelThemeSelectMenuItem *levelThemeMenuItem = (LevelThemeSelectMenuItem *)sender;
	[_game pushState:[LevelSelectMenuState stateWithTheme:[levelThemeMenuItem theme]]];
}

-(void) goBack:(id)sender
{
	[_game popState];
}

@end
