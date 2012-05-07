//
//  MainMenuState.m
//  Beezle
//
//  Created by Me on 24/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MainMenuState.h"
#import "DebugMenuState.h"
#import "Game.h"
#import "LevelThemeSelectMenuState.h"

@interface MainMenuState()

-(void) selectTheme:(id)sender;
-(void) testAnimations:(id)sender;

@end

@implementation MainMenuState

-(void) initialise
{
	[super initialise];
	
	_menu = [CCMenu menuWithItems:nil];
	
	CCMenuItem *playMenuItem = [CCMenuItemFont itemWithString:@"Play" target:self selector:@selector(selectTheme:)];
	[_menu addChild:playMenuItem];
#ifdef DEBUG
	CCMenuItem *debugMenuItem = [CCMenuItemFont itemWithString:@"Debug" target:self selector:@selector(testAnimations:)];
	[_menu addChild:debugMenuItem];
#endif
	
	[_menu alignItemsVerticallyWithPadding:20.0f];
	
	[self addChild:_menu];
	
	NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
	NSString* appName = [infoDict objectForKey:@"CFBundleDisplayName"];
	NSString* version = [infoDict objectForKey:@"CFBundleShortVersionString"];
	NSString *labelString = [NSString stringWithFormat:@"%@ %@", appName, version];
	CCLabelTTF *versionLabel = [CCLabelTTF labelWithString:labelString fontName:@"Marker Felt" fontSize:14.0f];
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	[versionLabel setPosition:CGPointMake(winSize.width, 0.0f)];
	[versionLabel setAnchorPoint:CGPointMake(1.0f, 0.0f)];
	[self addChild:versionLabel];
}

-(void) selectTheme:(id)sender
{
	[_game pushState:[LevelThemeSelectMenuState state]];
}

-(void) testAnimations:(id)sender
{
	[_game pushState:[DebugMenuState state]];
}

@end
