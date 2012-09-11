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
#import "SoundManager.h"
#import "PlayState.h"
#import "Utils.h"

@interface LevelThemeSelectMenuState()

-(void) createBackgroundSprite;
-(void) createBackMenu;
-(void) createScrollLayer:(NSArray *)themes;
-(void) updateBackground;

@end

@implementation LevelThemeSelectMenuState

-(void) initialise
{
	[super initialise];

	[self createBackgroundSprite];

	_chooserScreenBackSprite = [[CCSprite alloc] initWithFile:@"Chooser-Screen-back.png"];
	[_chooserScreenBackSprite setPosition:[Utils screenCenterPosition]];
	[self addChild:_chooserScreenBackSprite z:25];

	NSArray *themes = [[LevelOrganizer sharedOrganizer] themes];
	[self createScrollLayer:themes];

	CCSprite *chooserScreenFrontSprite = [CCSprite spriteWithFile:@"Chooser-Screen-front.png"];
	[chooserScreenFrontSprite setPosition:[Utils screenCenterPosition]];
	[self addChild:chooserScreenFrontSprite z:31];

	[self createBackMenu];
	[self updateBackground];
}

-(void) dealloc
{
	[_backgroundSprite release];
	[_scrollLayer release];
	[_chooserScreenBackSprite release];

	[super dealloc];
}

-(void) createBackgroundSprite
{
	_backgroundSprite = [CCSprite new];

	CCSprite *backgroundSprite1 = [CCSprite spriteWithFile:@"ChooserSlingerBackground-1.jpg"];
	[backgroundSprite1 setAnchorPoint:CGPointZero];
	[_backgroundSprite addChild:backgroundSprite1];

	CCSprite *backgroundSprite2 = [CCSprite spriteWithFile:@"ChooserSlingerBackground-2.jpg"];
	[backgroundSprite2 setAnchorPoint:CGPointZero];
	[backgroundSprite2 setPosition:CGPointMake([backgroundSprite1 contentSize].width, 0.0f)];
	[_backgroundSprite addChild:backgroundSprite2];

	_backgroundSpriteWidth = [backgroundSprite1 contentSize].width + [backgroundSprite2 contentSize].width;

	CGSize winSize = [[CCDirector sharedDirector] winSize];
	[_backgroundSprite setPosition:CGPointMake(0.0f, (winSize.height - [backgroundSprite1 contentSize].height) / 2)];
	[self addChild:_backgroundSprite];
}

-(void) createBackMenu
{
	CCMenu *backMenu = [CCMenu node];
	CCMenuItemImage *backMenuItem = [CCMenuItemImage itemWithNormalImage:@"ReturnArrow.png" selectedImage:@"ReturnArrow.png" block:^(id sender){
		[_game replaceState:[PlayState state]];
	}];
	[backMenuItem setPosition:CGPointMake(2.0f, 2.0f)];
	[backMenuItem setAnchorPoint:CGPointMake(0.0f, 0.0f)];
	[backMenu setPosition:CGPointZero];
	[backMenu addChild:backMenuItem];
	[self addChild:backMenu z:40];
}

-(void) createScrollLayer:(NSArray *)themes
{
	NSMutableArray *layers = [NSMutableArray array];
	for (NSString *theme in themes)
	{
		LevelThemeSelectLayer *levelThemeSelectLayer = [[[LevelThemeSelectLayer alloc] initWithTheme:theme startBlock:^(id sender){
			CCScaleTo *scaleAction = [CCScaleTo actionWithDuration:0.2f scale:1.5f];
			[_chooserScreenBackSprite runAction:scaleAction];
		} endBlock:^(id sender){
			[_game pushState:[LevelSelectMenuState stateWithTheme:theme]];
		}] autorelease];
		[layers addObject:levelThemeSelectLayer];
	}
	_scrollLayer =[[CCScrollLayer alloc] initWithLayers:layers widthOffset:0];
	[_scrollLayer setShowPagesIndicator:FALSE];
	[self addChild:_scrollLayer z:30];
}

-(void) enter
{
	[super enter];

	[[SoundManager sharedManager] playMusic:@"MusicMain"];
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
	float percent = -scrollLayerX / (([[_scrollLayer pages] count] - 1) * winSize.width);
	percent = min(percent, 1.0f);
	percent = max(percent, 0.0f);
	float backgroundSpritePadding = 120.0f;
	float backgroundSpriteX = backgroundSpritePadding - percent * (_backgroundSpriteWidth - winSize.width + 2 * backgroundSpritePadding);
	[_backgroundSprite setPosition:CGPointMake(backgroundSpriteX, [_backgroundSprite position].y)];
}

-(void) resetCurrentLevelThemeSelectLayer
{
	[_chooserScreenBackSprite setScale:1.0f];

	LevelThemeSelectLayer *layer = [[_scrollLayer pages] objectAtIndex:[_scrollLayer currentScreen]];
	[layer reset];
}

@end
