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
#import "CCScrollLayer.h"

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

-(void) dealloc
{
	[_scrollLayer release];

	[super dealloc];
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
	_scrollLayer =[[CCScrollLayer alloc] initWithLayers:layers widthOffset:0];
	[_scrollLayer setShowPagesIndicator:FALSE];
	[self addChild:_scrollLayer];
}

-(void) update:(ccTime)delta
{
	[super update:delta];

	CGSize winSize = [[CCDirector sharedDirector] winSize];
	float scrollLayerX = [_scrollLayer position].x;

	if ((int)scrollLayerX % (int)winSize.width == 0)
	{
		int currentLayerIndex = floorf((winSize.width / 2 - scrollLayerX) / winSize.width);
		currentLayerIndex = max(0, currentLayerIndex);
		currentLayerIndex = min([[_scrollLayer children] count] - 1, currentLayerIndex);
	}
	else
	{
		float centerX = winSize.width / 2 - scrollLayerX;
		float leftX = centerX - winSize.width / 2;
		int currentLeftLayerIndex = floorf(leftX / winSize.width);
		currentLeftLayerIndex = max(0, currentLeftLayerIndex);
		currentLeftLayerIndex = min([[_scrollLayer children] count] - 1, currentLeftLayerIndex);
		int currentRightLayerIndex = currentLeftLayerIndex + 1;
		currentRightLayerIndex = min([[_scrollLayer children] count] - 1, currentRightLayerIndex);
		float rightWidth = centerX + winSize.width / 2 - (currentRightLayerIndex * winSize.width);
		float rightRatio = rightWidth / winSize.width;
		float leftRatio = 1.0f - rightRatio;
	}
}

@end
