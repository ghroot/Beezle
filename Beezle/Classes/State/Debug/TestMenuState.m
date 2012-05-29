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
	[_menu addChild:testAnimationsMenuItem];
	CCMenuItemFont *testEntitySystemMenuItem = [CCMenuItemFont itemWithString:@"Test entity system" target:self selector:@selector(testEntitySystem:)];
	[_menu addChild:testEntitySystemMenuItem];
    
    CCMenuItemFont *backMenuItem = [CCMenuItemFont itemWithString:@"Back" target:self selector:@selector(goBack:)];
    [backMenuItem setFontSize:26.0f];
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
