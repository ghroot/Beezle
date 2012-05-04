//
//  DebugMenuState.m
//  Beezle
//
//  Created by Marcus on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DebugMenuState.h"
#import "Game.h"
#import "LevelSender.h"
#import "PlayerInformation.h"
#import "TestAnimationsState.h"

@interface DebugMenuState()

-(void) createMenu;
-(void) sendEditedLevels:(id)sender;
-(void) startTestAnimations:(id)sender;
-(void) toggleStats:(id)sender;
-(void) resetPlayerInformation:(id)sender;
-(void) goBack:(id)sender;

@end

@implementation DebugMenuState

-(void) initialise
{
	[super initialise];
	
    [self createMenu];
}

-(void) createMenu
{
    _menu = [CCMenu menuWithItems:nil];
	
	CCMenuItem *sendMenuItem = [CCMenuItemFont itemWithString:@"Send Edited Levels" target:self selector:@selector(sendEditedLevels:)];
	[_menu addChild:sendMenuItem];
	CCMenuItem *testAnimationsMenuItem = [CCMenuItemFont itemWithString:@"Test animations" target:self selector:@selector(startTestAnimations:)];
	[_menu addChild:testAnimationsMenuItem];
    CCMenuItem *toggleStatsMenuItem = [CCMenuItemFont itemWithString:@"Toggle stats" target:self selector:@selector(toggleStats:)];
	[_menu addChild:toggleStatsMenuItem];
	CCMenuItem *resetInfoMenuItem = [CCMenuItemFont itemWithString:@"Reset player information" target:self selector:@selector(resetPlayerInformation:)];
	[_menu addChild:resetInfoMenuItem];
    
    CCMenuItemFont *backMenuItem = [CCMenuItemFont itemWithString:@"Back" target:self selector:@selector(goBack:)];
    [backMenuItem setFontSize:24];
	[_menu addChild:backMenuItem];
	
	[_menu alignItemsVerticallyWithPadding:20.0f];
	
	[self addChild:_menu];
}

-(void) sendEditedLevels:(id)sender
{
    [[LevelSender sharedSender] sendEditedLevels];
}

-(void) startTestAnimations:(id)sender
{
    [_game replaceState:[TestAnimationsState state]];
}

-(void) toggleStats:(id)sender
{
    [[CCDirector sharedDirector] setDisplayStats:![[CCDirector sharedDirector] displayStats]];
}

-(void) resetPlayerInformation:(id)sender
{
    [[PlayerInformation sharedInformation] reset];
}

-(void) goBack:(id)sender
{
	[_game popState];
}

@end
