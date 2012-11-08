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
#import "SoundManager.h"
#import "PlayState.h"
#import "Utils.h"
#import "PlayerInformation.h"
#import "BeesFrontNode.h"

static BOOL isFirstLoad = TRUE;
static const int NUMBER_OF_SECTIONS_IN_BACKGROUND_IMAGE = 4;

@interface LevelThemeSelectMenuState()

-(void) createBackgroundSprite;
-(void) createBackMenu;
-(void) createScrollLayer:(NSArray *)themes;
-(void) updateBackground;
-(void) updatePageDots:(int)page;
-(void) updateArrows:(int)page;

@end

@implementation LevelThemeSelectMenuState

+(id) stateWithPreselectedTheme:(NSString *)theme
{
	return [[[self alloc] initWithPreselectedTheme:theme] autorelease];
}

-(id) initWithPreselectedTheme:(NSString *)theme
{
	if (self = [super init])
	{
		_theme = [theme copy];
		_pageDotSprites = [NSMutableArray new];
		if (isFirstLoad)
		{
			_needsLoadingState = TRUE;
			isFirstLoad = FALSE;
		}
	}
	return self;
}

-(id) init
{
	return [self initWithPreselectedTheme:[[[LevelOrganizer sharedOrganizer] themes] objectAtIndex:0]];
}

-(void) initialise
{
	[super initialise];

	[self createBackgroundSprite];

	CCSprite *chooserScreenBackSprite = [CCSprite spriteWithFile:@"Chooser-Screen.png"];
	[chooserScreenBackSprite setPosition:[Utils screenCenterPosition]];
	[self addChild:chooserScreenBackSprite z:25];

	NSArray *themes = [[LevelOrganizer sharedOrganizer] themes];
	[self createScrollLayer:themes];

	_numberOfPages = [themes count];

	[self addChild:[BeesFrontNode node] z:31];

	CGSize winSize = [[CCDirector sharedDirector] winSize];

	_arrowLeftSprite = [CCSprite spriteWithFile:@"Symbol-Scroll-White.png"];
	[_arrowLeftSprite setScaleX:-1.0f];
	[_arrowLeftSprite setAnchorPoint:CGPointMake(1.0f, 0.5f)];
	[_arrowLeftSprite setPosition:CGPointMake(5.0f, winSize.height / 2)];
	[self addChild:_arrowLeftSprite z:32];

	_arrowRightSprite = [CCSprite spriteWithFile:@"Symbol-Scroll-White.png"];
	[_arrowRightSprite setAnchorPoint:CGPointMake(1.0f, 0.5f)];
	[_arrowRightSprite setPosition:CGPointMake(winSize.width - 5.0f, winSize.height / 2)];
	[self addChild:_arrowRightSprite z:32];

	[self createBackMenu];

	int index = [themes indexOfObject:_theme];
	[_scrollLayer selectPage:index];

	[self updateBackground];
    [self updatePageDots:index];
    [self updateArrows:index];
}

-(void) dealloc
{
	[_backgroundSprite release];
	[_scrollLayer release];
	[_pageDotSprites release];
	[_theme release];

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
	CCMenuItemImage *backMenuItem = [CCMenuItemImage itemWithNormalImage:@"Symbol-Next-White.png" selectedImage:@"Symbol-Next-White.png" block:^(id sender){
		[_game replaceState:[PlayState state]];
	}];
	[backMenuItem setScaleX:-1.0f];
	[backMenuItem setPosition:CGPointMake(2.0f, 2.0f)];
	[backMenuItem setAnchorPoint:CGPointMake(1.0f, 0.0f)];
	[backMenu setPosition:CGPointZero];
	[backMenu addChild:backMenuItem];
	[self addChild:backMenu z:40];
}

-(void) createScrollLayer:(NSArray *)themes
{
	NSMutableArray *layers = [NSMutableArray array];
	for (NSString *theme in themes)
	{
		LevelThemeSelectLayer *levelThemeSelectLayer = [[[LevelThemeSelectLayer alloc] initWithTheme:theme game:_game locked:![[PlayerInformation sharedInformation] canPlayTheme:theme]] autorelease];
		[layers addObject:levelThemeSelectLayer];
	}
	_scrollLayer = [[CCScrollLayer alloc] initWithLayers:layers widthOffset:0];
	[_scrollLayer setShowPagesIndicator:FALSE];
    [_scrollLayer setDelegate:self];
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
	float percent = -scrollLayerX / ((NUMBER_OF_SECTIONS_IN_BACKGROUND_IMAGE - 1) * winSize.width);
	percent = min(percent, 1.0f);
	percent = max(percent, 0.0f);
	float backgroundSpritePadding = 120.0f;
	float backgroundSpriteX = backgroundSpritePadding - percent * (_backgroundSpriteWidth - winSize.width + 2 * backgroundSpritePadding);
	[_backgroundSprite setPosition:CGPointMake(backgroundSpriteX, [_backgroundSprite position].y)];
}

-(void) scrollLayer:(CCScrollLayer *)sender scrolledToPageNumber:(int)page
{
    [self updatePageDots:page];
	[self updateArrows:page];
}

-(void) updatePageDots:(int)page
{
	for (CCSprite *pageDotSprite in _pageDotSprites)
	{
		[self removeChild:pageDotSprite cleanup:TRUE];
	}
	[_pageDotSprites removeAllObjects];

	float universalScreenStartX = [Utils universalScreenStartX];

	for (int i = 0; i < [[_scrollLayer pages] count]; i++)
	{
		CCSprite *pageDotSprite = nil;
		if (i == page)
		{
			pageDotSprite = [CCSprite spriteWithFile:@"PageDot-full.png"];
		}
		else
		{
			pageDotSprite = [CCSprite spriteWithFile:@"PageDot-diff.png"];
		}
		[pageDotSprite setPosition:CGPointMake(universalScreenStartX + 220.0f + i * 10.0f, 20.0f)];
		[_pageDotSprites addObject:pageDotSprite];
		[self addChild:pageDotSprite z:35];
	}
}

-(void) updateArrows:(int)page
{
	[_arrowLeftSprite setVisible:page > 0];
	[_arrowRightSprite setVisible:page < _numberOfPages - 1];
}

@end
