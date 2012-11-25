//
//  LevelThemeSelectMenuState.m
//  Beezle
//
//  Created by KM Lagerstrom on 11/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LevelThemeSelectMenuState.h"
#import "Game.h"
#import "LevelThemeSelectLayer.h"
#import "LevelSelectMenuState.h"
#import "SoundManager.h"
#import "PlayState.h"
#import "Utils.h"
#import "BeesFrontNode.h"
#import "PlayerInformation.h"
#import "LevelOrganizer.h"

static BOOL isFirstLoad = TRUE;
static const float PAGE_DOT_DISTANCE = 10.0f;

@interface LevelThemeSelectMenuState()

-(void) createBackgroundSprite;
-(void) createBackMenu;
-(void) createScrollLayer;
-(void) updateBackground;
-(void) updatePageDots:(int)page;

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
	return [self initWithPreselectedTheme:[[[PlayerInformation sharedInformation] visibleThemes] objectAtIndex:0]];
}

-(void) initialise
{
	[super initialise];

#ifdef DEBUG
	_themes = [[[LevelOrganizer sharedOrganizer] themes] retain];
#else
	_themes = [[[PlayerInformation sharedInformation] visibleThemes] retain];
#endif

	[self createBackgroundSprite];

	CCSprite *chooserScreenBackSprite = [CCSprite spriteWithFile:@"Chooser-Screen.png"];
	[chooserScreenBackSprite setPosition:[Utils screenCenterPosition]];
	[self addChild:chooserScreenBackSprite z:25];

	CGSize winSize = [[CCDirector sharedDirector] winSize];
	_layerOffset = (int)(winSize.width * 0.42f);

	[self createScrollLayer];

	_numberOfPages = [_themes count];

	[self addChild:[BeesFrontNode node] z:31];

	[self createBackMenu];

	int index = [_themes indexOfObject:_theme];
	[_scrollLayer selectPage:index];

	[self updateBackground];
    [self updatePageDots:index];
}

-(void) dealloc
{
	[_themes release];
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
	_backgroundSpriteWidth += [backgroundSprite1 contentSize].width;

	if ([_themes count] > 2)
	{
		CCSprite *backgroundSprite2 = [CCSprite spriteWithFile:@"ChooserSlingerBackground-2.jpg"];
		[backgroundSprite2 setAnchorPoint:CGPointZero];
		[backgroundSprite2 setPosition:CGPointMake(_backgroundSpriteWidth, 0.0f)];
		[_backgroundSprite addChild:backgroundSprite2];
		if ([_themes count] > 3)
		{
			_backgroundSpriteWidth += [backgroundSprite2 contentSize].width;
		}
		else
		{
			_backgroundSpriteWidth += [backgroundSprite2 contentSize].width / 2;
		}
	}

	if ([_themes count] > 4)
	{
		CCSprite *backgroundSprite3 = [CCSprite spriteWithFile:@"ChooserSlingerBackground-3.jpg"];
		[backgroundSprite3 setAnchorPoint:CGPointZero];
		[backgroundSprite3 setPosition:CGPointMake(_backgroundSpriteWidth, 0.0f)];
		[_backgroundSprite addChild:backgroundSprite3];
		_backgroundSpriteWidth += [backgroundSprite3 contentSize].width;
	}

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

-(void) createScrollLayer
{
	NSMutableArray *layers = [NSMutableArray array];
	for (NSString *theme in _themes)
	{
		LevelThemeSelectLayer *levelThemeSelectLayer = [LevelThemeSelectLayer layerWithTheme:theme game:_game];
		[layers addObject:levelThemeSelectLayer];
	}
	_scrollLayer = [[CCScrollLayer alloc] initWithLayers:layers widthOffset:_layerOffset];
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
	float percent = -scrollLayerX / (([_themes count] - 1) * (winSize.width - _layerOffset));
	percent = min(percent, 1.0f);
	percent = max(percent, 0.0f);
	float backgroundSpritePadding = 120.0f;
	float backgroundSpriteX = backgroundSpritePadding - percent * (_backgroundSpriteWidth - winSize.width + 2 * backgroundSpritePadding);
	[_backgroundSprite setPosition:CGPointMake(backgroundSpriteX, [_backgroundSprite position].y)];
}

-(void) scrollLayer:(CCScrollLayer *)sender scrolledToPageNumber:(int)page
{
    [self updatePageDots:page];
}

-(void) updatePageDots:(int)page
{
	for (CCSprite *pageDotSprite in _pageDotSprites)
	{
		[self removeChild:pageDotSprite cleanup:TRUE];
	}
	[_pageDotSprites removeAllObjects];

	CGSize winSize = [[CCDirector sharedDirector] winSize];
	int numberOfPages = [[_scrollLayer pages] count];
	float startX = (winSize.width - PAGE_DOT_DISTANCE * (numberOfPages - 1)) / 2.0f;
	for (int i = 0; i < numberOfPages; i++)
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
		[pageDotSprite setPosition:CGPointMake(startX + i * PAGE_DOT_DISTANCE, 20.0f)];
		[_pageDotSprites addObject:pageDotSprite];
		[self addChild:pageDotSprite z:35];
	}
}

@end
