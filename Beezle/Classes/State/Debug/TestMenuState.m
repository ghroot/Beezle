//
//  TestMenuState.m
//  Beezle
//
//  Created by KM Lagerstrom on 28/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TestMenuState.h"
#import "Game.h"
#import "TestAnimationsState.h"
#import "TestEntitySystemState.h"
#import "TestCreditsState.h"
#import "GameCenterManager.h"
#import "TestLevelLayoutsState.h"
#import "iRate.h"
#import "TestCCBState.h"
#import "TestSlingerSpaceState.h"
#import "TestVisualState.h"

@interface TestMenuState()

-(void) createMenu;
-(void) testAnimations:(id)sender;
-(void) testEntitySystem:(id)sender;
-(void) goBack:(id)sender;

@end

@implementation TestMenuState

-(void) initialise
{
	[super initialise];
	
    [self createMenu];
}

-(void) createMenu
{
    _menu = [CCMenu menuWithItems:nil];
	
	CCMenuItemFont *testAnimationsMenuItem = [CCMenuItemFont itemWithString:@"Test animations" target:self selector:@selector(testAnimations:)];
	[testAnimationsMenuItem setFontSize:24];
	[_menu addChild:testAnimationsMenuItem];
	CCMenuItemFont *testEntitySystemMenuItem = [CCMenuItemFont itemWithString:@"Test entity system" target:self selector:@selector(testEntitySystem:)];
	[testEntitySystemMenuItem setFontSize:24];
	[_menu addChild:testEntitySystemMenuItem];
	CCMenuItemFont *testCreditsMenuItem = [CCMenuItemFont itemWithString:@"Test credits" block:^(id sender){
		[_game pushState:[TestCreditsState state]];
	}];
	[testCreditsMenuItem setFontSize:24];
	[_menu addChild:testCreditsMenuItem];
	CCMenuItemFont *testLevelLayoutsMenuItem = [CCMenuItemFont itemWithString:@"Test level layouts" block:^(id sender){
		[_game pushState:[TestLevelLayoutsState state]];
	}];
	[testLevelLayoutsMenuItem setFontSize:24];
	[_menu addChild:testLevelLayoutsMenuItem];
	CCMenuItemFont *testSlingerSpaceMenuItem = [CCMenuItemFont itemWithString:@"Test slinger space" block:^(id sender){
		[_game pushState:[TestSlingerSpaceState state]];
	}];
	[testSlingerSpaceMenuItem setFontSize:24];
	[_menu addChild:testSlingerSpaceMenuItem];
	CCMenuItemFont *testCCBMenuItem = [CCMenuItemFont itemWithString:@"Test CCB" block:^(id sender){
		[_game pushState:[TestCCBState state]];
	}];
	[testCCBMenuItem setFontSize:24];
	[_menu addChild:testCCBMenuItem];
	CCMenuItemFont *testRatingMenuItem = [CCMenuItemFont itemWithString:@"Test rating" block:^(id sender){
		[[iRate sharedInstance] promptForRating];
	}];
	[testRatingMenuItem setFontSize:24];
	[_menu addChild:testRatingMenuItem];
	CCMenuItemFont *testVisualMenuItem = [CCMenuItemFont itemWithString:@"Test visual" block:^(id sender){
		[_game pushState:[TestVisualState state]];
	}];
	[testVisualMenuItem setFontSize:24];
	[_menu addChild:testVisualMenuItem];

    CCMenuItemFont *backMenuItem = [CCMenuItemFont itemWithString:@"Back" target:self selector:@selector(goBack:)];
    [backMenuItem setFontSize:26];
	[_menu addChild:backMenuItem];
	
	[_menu alignItemsVerticallyWithPadding:6.0f];
	
	[self addChild:_menu];
}

-(void) testAnimations:(id)sender
{
	[_game pushState:[TestAnimationsState state]];
}

-(void) testEntitySystem:(id)sender
{
	[_game pushState:[TestEntitySystemState state]];
}

-(void) goBack:(id)sender
{
	[_game popState];
}

@end
