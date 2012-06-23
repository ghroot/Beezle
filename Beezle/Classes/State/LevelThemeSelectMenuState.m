//
//  LevelThemeSelectMenuState.m
//  Beezle
//
//  Created by KM Lagerstrom on 11/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LevelThemeSelectMenuState.h"
#import "Game.h"
#import "LevelOrganizer.h"
#import "LevelThemeSelectLayer.h"
#import "LevelSelectMenuState.h"

@interface LevelThemeSelectMenuState()

-(void) createBackMenu;
-(void) createScrollLayers;

@end

@implementation LevelThemeSelectMenuState

-(void) initialise
{
	[super initialise];

	[self createScrollLayers];
	[self createBackMenu];
}

-(void) createBackMenu
{
	CCMenu *menu = [CCMenu menuWithItems:nil];
	CCMenuItemFont *backMenuItem = [CCMenuItemFont itemWithString:@"Back" block:^(id sender){
		[_game popState];
	}];
	[backMenuItem setFontSize:24];
	[backMenuItem setAnchorPoint:CGPointMake(0.0f, 0.0f)];
	[menu addChild:backMenuItem];
	[menu setPosition:CGPointMake(0.0f, 0.0f)];
	[menu setAnchorPoint:CGPointMake(1.0f, 1.0f)];
	[self addChild:menu];
}

-(void) createScrollLayers
{
	NSMutableArray *layers = [NSMutableArray array];
	NSArray *themes = [[LevelOrganizer sharedOrganizer] themes];
	for (NSString *theme in themes)
	{
		LevelThemeSelectLayer *levelThemeSelectLayer = [[[LevelThemeSelectLayer alloc] initWithTheme:theme block:^(id sender){
			[_game pushState:[LevelSelectMenuState stateWithTheme:theme]];
		}] autorelease];
		[layers addObject:levelThemeSelectLayer];
	}
	CCScrollLayer *scrollLayer = [CCScrollLayer nodeWithLayers:layers widthOffset:0];
	[scrollLayer setShowPagesIndicator:FALSE];
	[self addChild:scrollLayer];
}

@end
