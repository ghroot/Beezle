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

	[self setLayerOpacities];
}

-(void) setLayerOpacities
{
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	float scrollLayerX = [_scrollLayer position].x;
	float centerX = winSize.width / 2 - scrollLayerX;
	float leftX = centerX - winSize.width / 2;
	int currentLeftLayerIndex = floorf(leftX / winSize.width);
	currentLeftLayerIndex = max(0, currentLeftLayerIndex);
	currentLeftLayerIndex = min([[_scrollLayer children] count] - 1, currentLeftLayerIndex);
	float rightX = centerX + winSize.width / 2;
	int currentRightLayerIndex = floorf(rightX / winSize.width);
	currentRightLayerIndex = max(0, currentRightLayerIndex);
	currentRightLayerIndex = min([[_scrollLayer children] count] - 1, currentRightLayerIndex);

	if ((int)scrollLayerX % (int)winSize.width == 0 ||
		currentLeftLayerIndex == currentRightLayerIndex)
	{
		CCLayer *layer = [[_scrollLayer children] objectAtIndex:currentLeftLayerIndex];
		for (CCNode *node in [layer children])
		{
			if ([node conformsToProtocol:@protocol(CCRGBAProtocol)])
			{
				[(id<CCRGBAProtocol>) node setOpacity:255];
			}
		}
	}
	else
	{
		float rightWidth = centerX + winSize.width / 2 - (currentRightLayerIndex * winSize.width);
		float rightRatio = rightWidth / winSize.width;
		float leftRatio = 1.0f - rightRatio;

		CCLayer *leftLayer = [[_scrollLayer children] objectAtIndex:currentLeftLayerIndex];
		for (CCNode *node in [leftLayer children])
		{
			if ([node conformsToProtocol:@protocol(CCRGBAProtocol)])
			{
				[(id<CCRGBAProtocol>) node setOpacity:255 * leftRatio];
			}
		}

		CCLayer *rightLayer = [[_scrollLayer children] objectAtIndex:currentRightLayerIndex];
		for (CCNode *node in [rightLayer children])
		{
			if ([node conformsToProtocol:@protocol(CCRGBAProtocol)])
			{
				[(id<CCRGBAProtocol>) node setOpacity:255 * rightRatio];
			}
		}
	}
}

@end
