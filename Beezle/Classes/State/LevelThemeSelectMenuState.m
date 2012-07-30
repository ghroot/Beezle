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

-(void) createBackgroundSprites:(NSArray *)themes;
-(void) createBackMenu;
-(void) createScrollLayer:(NSArray *)themes;
-(void) updateBackground;

@end

@implementation LevelThemeSelectMenuState

-(void) initialise
{
	[super initialise];

	_activeBackgroundSprites = [NSMutableArray new];

//	CCLayerColor *whiteBackgroundLayer = [CCLayerColor layerWithColor:ccc4(255, 255, 255, 255)];
//	[self addChild:whiteBackgroundLayer];

	NSArray *themes = [[LevelOrganizer sharedOrganizer] themes];

	[self createBackgroundSprites:themes];
	[self createScrollLayer:themes];
	[self createBackMenu];
	[self updateBackground];
}

-(void) dealloc
{
	[_backgroundSprites release];
	[_scrollLayer release];

	[super dealloc];
}

-(void) createBackgroundSprites:(NSArray *)themes
{
	_backgroundSprites = [NSMutableArray new];
	for (NSString *theme in themes)
	{
		CCSprite *backgroundSprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"Colour-%@.jpg", theme]];
		[backgroundSprite setAnchorPoint:CGPointMake(0.0f, 0.0f)];
		[_backgroundSprites addObject:backgroundSprite];
	}
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
	[self addChild:menu z:30];
}

-(void) createScrollLayer:(NSArray *)themes
{
	NSMutableArray *layers = [NSMutableArray array];
	for (NSString *theme in themes)
	{
		LevelThemeSelectLayer *levelThemeSelectLayer = [[[LevelThemeSelectLayer alloc] initWithTheme:theme block:^(id sender){
			[_game pushState:[LevelSelectMenuState stateWithTheme:theme]];
		}] autorelease];
		[layers addObject:levelThemeSelectLayer];
	}
	_scrollLayer =[[CCScrollLayer alloc] initWithLayers:layers widthOffset:0];
	[_scrollLayer setShowPagesIndicator:FALSE];
	[self addChild:_scrollLayer z:20];
}

-(void) enter
{
	[super enter];

	for (LevelThemeSelectLayer *layer in [_scrollLayer pages])
	{
		[layer reset];
	}
}

-(void) update:(ccTime)delta
{
	[super update:delta];

	[self updateBackground];
}

-(void) updateBackground
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

	for (CCSprite *sprite in _activeBackgroundSprites)
	{
		[self removeChild:sprite cleanup:TRUE];
	}
	[_activeBackgroundSprites removeAllObjects];

	if ((int)scrollLayerX % (int)winSize.width == 0 ||
		currentLeftLayerIndex == currentRightLayerIndex)
	{
		CCSprite *sprite = [_backgroundSprites objectAtIndex:currentLeftLayerIndex];
		[sprite setOpacity:255];
		[self addChild:sprite z:10];
		[_activeBackgroundSprites addObject:sprite];
	}
	else
	{
		float rightWidth = centerX + winSize.width / 2 - (currentRightLayerIndex * winSize.width);
		float rightRatio = rightWidth / winSize.width;
		float leftRatio = 1.0f - rightRatio;

		CCSprite *leftSprite = [_backgroundSprites objectAtIndex:currentLeftLayerIndex];
		CCSprite *rightSprite = [_backgroundSprites objectAtIndex:currentRightLayerIndex];

		[leftSprite setOpacity:255 * leftRatio];
		[rightSprite setOpacity:255 * rightRatio];

		[self addChild:leftSprite z:10];
		[self addChild:rightSprite z:10];

		[_activeBackgroundSprites addObject:leftSprite];
		[_activeBackgroundSprites addObject:rightSprite];
	}
}

@end
