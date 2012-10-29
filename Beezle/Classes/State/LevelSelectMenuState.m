//
//  LevelSelectMenuState.m
//  Beezle
//
//  Created by Me on 02/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LevelSelectMenuState.h"
#import "Game.h"
#import "CCBReader.h"
#import "PlayerInformation.h"
#import "LevelThemeSelectMenuState.h"
#import "ScrollView.h"
#import "SoundManager.h"
#import "LevelLayout.h"
#import "LevelLayoutCache.h"
#import "BeesFrontNode.h"
#import "Utils.h"
#import "GameStateUtils.h"
#import "LevelRatings.h"
#import "LevelRating.h"

@interface LevelSelectMenuState()

-(void) addInterfaceLevelsMenu;
-(CCMenu *) getMenu:(CCNode *)node;
-(void) createBackMenu;
-(void) startGame:(id)sender;

@end

@implementation LevelSelectMenuState

+(LevelSelectMenuState *) stateWithTheme:(NSString *)theme
{
	return [[[self alloc] initWithTheme:theme] autorelease];
}

// Designated initialiser
-(id) initWithTheme:(NSString *)theme
{
    if (self = [super init])
    {
		_theme = [theme copy];
    }
    return self;
}

-(id) init
{
	return [self initWithTheme:nil];
}

-(void) initialise
{
	[super initialise];

    [self addInterfaceLevelsMenu];
	[self createBackMenu];
}

-(void) addInterfaceLevelsMenu
{
	CGSize winSize = [[CCDirector sharedDirector] winSize];

	CCSprite *backgroundSprite = [CCSprite node];
	CCSprite *backgroundSprite1 = [CCSprite spriteWithFile:@"ChooserSlingerBackground-1.jpg"];
	[backgroundSprite1 setAnchorPoint:CGPointZero];
	[backgroundSprite addChild:backgroundSprite1];
	CCSprite *backgroundSprite2 = [CCSprite spriteWithFile:@"ChooserSlingerBackground-2.jpg"];
	[backgroundSprite2 setAnchorPoint:CGPointZero];
	[backgroundSprite2 setPosition:CGPointMake([backgroundSprite1 contentSize].width, 0.0f)];
	[backgroundSprite addChild:backgroundSprite2];
	float backgroundSpriteX;
	if ([_theme isEqualToString:@"A"])
	{
		backgroundSpriteX = 0.0f;
	}
	else if ([_theme isEqualToString:@"B"])
	{
		backgroundSpriteX = -500.0f;
	}
	else if ([_theme isEqualToString:@"C"])
	{
		backgroundSpriteX = -1000.0f;
	}
	else
	{
		backgroundSpriteX = -1500.0f;
	}
	[backgroundSprite setPosition:CGPointMake(backgroundSpriteX, (winSize.height - [backgroundSprite1 contentSize].height) / 2)];
	[self addChild:backgroundSprite];

	_chooserScreenBackSprite = [[CCSprite alloc] initWithFile:@"Chooser-Screen-back.png"];
	[_chooserScreenBackSprite setPosition:[Utils screenCenterPosition]];
	[self addChild:_chooserScreenBackSprite];

	float lastCanPlayCellX = 0.0f;

//    NSString *nodeFileName = [NSString stringWithFormat:@"LevelSelect-%@.ccbi", _theme];
    NSString *nodeFileName = @"LevelSelect-A.ccbi";
	CCNode *draggableNode = [CCBReader nodeGraphFromFile:nodeFileName owner:self];
    CCMenu *menu = [self getMenu:draggableNode];
    for (CCMenuItemImage *menuItemImage in [menu children])
    {
        NSString *levelName = [NSString stringWithFormat:@"Level-%@%d", _theme, [menuItemImage tag]];
		LevelLayout *levelLayout = [[LevelLayoutCache sharedLevelLayoutCache] levelLayoutByName:levelName];
        if ([[PlayerInformation sharedInformation] canPlayLevel:levelName])
        {
            NSString *openImageName = [NSString stringWithFormat:@"LevelCell-%@-Open.png", _theme];
            [menuItemImage setNormalImage:[CCSprite spriteWithFile:openImageName]];
            [menuItemImage setSelectedImage:[CCSprite spriteWithFile:openImageName]];
            [menuItemImage setDisabledImage:[CCSprite spriteWithFile:openImageName]];

			lastCanPlayCellX = [menuItemImage position].x;
        }
		else
		{
			NSString *imageName;
			if ([levelLayout isBossLevel])
			{
				imageName = [NSString stringWithFormat:@"LevelCell-%@-Beeater.png", _theme];
			}
			else
			{
				imageName = [NSString stringWithFormat:@"LevelCell-%@-Bee.png", _theme];
			}
			[menuItemImage setNormalImage:[CCSprite spriteWithFile:imageName]];
			[menuItemImage setSelectedImage:[CCSprite spriteWithFile:imageName]];
			[menuItemImage setDisabledImage:[CCSprite spriteWithFile:imageName]];
		}

		CGPoint position = [menuItemImage position];

		if ([[PlayerInformation sharedInformation] canPlayLevel:levelName])
		{
			NSString *levelString = [NSString stringWithFormat:@"%d", [menuItemImage tag]];
			CCLabelAtlas *label = [CCLabelAtlas labelWithString:levelString charMapFile:@"numberImages.png" itemWidth:25 itemHeight:30 startCharMap:'/'];
			[label setAnchorPoint:CGPointMake(0.5f, 0.5f)];
			[label setPosition:CGPointMake(position.x, position.y + 6)];
			[draggableNode addChild:label];

			int flowerRecord = [[PlayerInformation sharedInformation] flowerRecordForLevel:levelName];
			CCSprite *flowerSprite1 = [CCSprite spriteWithFile:(flowerRecord >= 1 ? @"Flower-Cell-full.png" : @"Flower-Cell-dim.png")];
			[flowerSprite1 setPosition:CGPointMake(position.x - 12.0f, position.y - 18.0f)];
			[draggableNode addChild:flowerSprite1];
			CCSprite *flowerSprite2 = [CCSprite spriteWithFile:(flowerRecord >= 2 ? @"Flower-Cell-full.png" : @"Flower-Cell-dim.png")];
			[flowerSprite2 setPosition:CGPointMake(position.x, position.y - 18.0f)];
			[draggableNode addChild:flowerSprite2];
			CCSprite *flowerSprite3 = [CCSprite spriteWithFile:(flowerRecord == 3 ? @"Flower-Cell-full.png" : @"Flower-Cell-dim.png")];
			[flowerSprite3 setPosition:CGPointMake(position.x + 12.0f, position.y - 18.0f)];
			[draggableNode addChild:flowerSprite3];
		}
		else
		{
#ifndef DEBUG
			[menuItemImage setIsEnabled:FALSE];
#endif
		}

#ifdef DEBUG
		NSString *levelString = [NSString stringWithFormat:@"%d", [menuItemImage tag]];
		CCLabelTTF *debugLabel = [CCLabelTTF labelWithString:levelString fontName:@"Marker Felt" fontSize:24];
		[debugLabel setAnchorPoint:CGPointMake(0.5f, 0.5f)];
		[debugLabel setPosition:position];
		if ([[LevelRatings sharedRatings] hasRatedLevel:levelName withVersion:[levelLayout version]])
		{
			LevelRating *rating = [[LevelRatings sharedRatings] ratingForLevel:levelName];
			if ([rating numberOfStars] == 1)
			{
				[debugLabel setColor:ccc3(255, 0, 0)];
			}
			else if ([rating numberOfStars] == 2)
			{
				[debugLabel setColor:ccc3(255, 255, 0)];
			}
			else if ([rating numberOfStars] == 3)
			{
				[debugLabel setColor:ccc3(0, 255, 0)];
			}
		}
		[draggableNode addChild:debugLabel];
#endif
    }
	[draggableNode setContentSize:CGSizeMake(1200.0f, winSize.height)];
	[draggableNode setPosition:CGPointMake(max(winSize.width - 1200.0f, min(0.0f, winSize.width / 2 - lastCanPlayCellX)), 0.0f)];

	_scrollView = [[ScrollView alloc] initWithContent:draggableNode];
	[self addChild:_scrollView];

	_beesFrontNode = [BeesFrontNode new];
	[self addChild:_beesFrontNode];

	_fadeLayer = [[CCLayerColor alloc] initWithColor:ccc4(0, 0, 0, 0)];
	[self addChild:_fadeLayer z:32];
}

-(CCMenu *) getMenu:(CCNode *)node
{
    for (CCNode *childNode in [node children])
	{
		if ([childNode isKindOfClass:[CCMenu class]])
		{
            return (CCMenu *)childNode;
		}
	}
    return nil;
}

-(void) createBackMenu
{
    CCMenu *backMenu = [CCMenu node];
	CCMenuItemImage *backMenuItem = [CCMenuItemImage itemWithNormalImage:@"Symbol-Next-White.png" selectedImage:@"Symbol-Next-White.png" block:^(id sender){
        if ([_scrollView didDragSignificantDistance])
        {
            return;
        }

		[_game replaceState:[LevelThemeSelectMenuState stateWithPreselectedTheme:_theme]];
	}];
	[backMenuItem setScaleX:-1.0f];
	[backMenuItem setPosition:CGPointMake(2.0f, 2.0f)];
	[backMenuItem setAnchorPoint:CGPointMake(1.0f, 0.0f)];
	[backMenu setPosition:CGPointZero];
	[backMenu addChild:backMenuItem];
	[self addChild:backMenu];
}

-(void) dealloc
{
	[_theme release];
	[_scrollView release];
	[_chooserScreenBackSprite release];
	[_beesFrontNode release];
	[_fadeLayer release];
	
	[super dealloc];
}

-(void) enter
{
	[super enter];

	[[SoundManager sharedManager] playMusic:@"MusicMain"];
}

-(void) startGame:(id)sender
{
    if ([_scrollView didDragSignificantDistance])
    {
        return;
    }

	CCMenuItemImage *menuItem = (CCMenuItemImage *)sender;
	NSString *levelName = [NSString stringWithFormat:@"Level-%@%d", _theme, [menuItem tag]];

	// TODO: Fade out
	[self removeChild:_scrollView cleanup:TRUE];

	CCScaleTo *scaleAction = [CCScaleTo actionWithDuration:0.35f scale:1.5f];
	CCCallBlock *gotoGameAction = [CCCallBlock actionWithBlock:^{
		[GameStateUtils replaceWithGameplayState:levelName game:_game];
	}];
	[_chooserScreenBackSprite runAction:[CCSequence actionOne:scaleAction two:gotoGameAction]];

	CCMoveTo *moveAction = [CCMoveTo actionWithDuration:0.3f position:CGPointMake(0.0f, -20.0f)];
	[_beesFrontNode runAction:moveAction];

	CCFadeIn *fadeInAction = [CCFadeIn actionWithDuration:0.3f];
	[_fadeLayer runAction:fadeInAction];
}

@end
