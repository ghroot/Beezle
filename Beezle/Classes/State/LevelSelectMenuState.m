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
#import "GameStateUtils.h"
#import "BeesFrontNode.h"

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

	CCSprite *chooserScreenBackSprite = [CCSprite spriteWithFile:@"Chooser-Screen-back.png"];
	[chooserScreenBackSprite setAnchorPoint:CGPointZero];
	[self addChild:chooserScreenBackSprite];

//    NSString *nodeFileName = [NSString stringWithFormat:@"LevelSelect-%@.ccbi", _theme];
    NSString *nodeFileName = @"LevelSelect-A.ccbi";
	CCNode *draggableNode = [CCBReader nodeGraphFromFile:nodeFileName owner:self];
    CCMenu *menu = [self getMenu:draggableNode];
    for (CCMenuItemImage *menuItemImage in [menu children])
    {
        NSString *levelName = [NSString stringWithFormat:@"Level-%@%d", _theme, [menuItemImage tag]];
        if ([[PlayerInformation sharedInformation] pollenRecord:levelName] > 0)
        {
            NSString *openImageName = [NSString stringWithFormat:@"LevelCell-%@-Open.png", _theme];
            [menuItemImage setNormalImage:[CCSprite spriteWithFile:openImageName]];
            [menuItemImage setSelectedImage:[CCSprite spriteWithFile:openImageName]];
            [menuItemImage setDisabledImage:[CCSprite spriteWithFile:openImageName]];
        }
		else
		{
			NSString *imageName;
			LevelLayout *levelLayout = [[LevelLayoutCache sharedLevelLayoutCache] levelLayoutByName:levelName];
			if ([levelLayout hasEntityWithType:@"SUPER-BEEATER-A"] ||
				[levelLayout hasEntityWithType:@"SUPER-BEEATER-B"] ||
				[levelLayout hasEntityWithType:@"SUPER-BEEATER-C"] ||
				[levelLayout hasEntityWithType:@"SUPER-BEEATER-D"])
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

#ifdef DEBUG
		NSString *levelString = [NSString stringWithFormat:@"%d", [menuItemImage tag]];
		CCLabelAtlas *label = [[[CCLabelAtlas alloc] initWithString:levelString charMapFile:@"numberImages.png" itemWidth:25 itemHeight:30 startCharMap:'/'] autorelease];
		[label setAnchorPoint:CGPointMake(0.5f, 0.5f)];
		[label setPosition:position];
		[draggableNode addChild:label];

		int flowerRecord = [[PlayerInformation sharedInformation] flowerRecordForLevel:levelName];
		if (flowerRecord > 0)
		{
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
#else
		if ([[PlayerInformation sharedInformation] hasPlayedLevel:levelName])
		{
			NSString *levelString = [NSString stringWithFormat:@"%d", [menuItemImage tag]];
			CCLabelAtlas *label = [[[CCLabelAtlas alloc] initWithString:levelString charMapFile:@"numberImages.png" itemWidth:25 itemHeight:30 startCharMap:'/'] autorelease];
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
#endif
    }
	[draggableNode setContentSize:CGSizeMake(1200.0f, winSize.height)];

	_scrollView = [[ScrollView alloc] initWithContent:draggableNode];
	[self addChild:_scrollView];

	[self addChild:[BeesFrontNode node]];
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
	CCMenuItemImage *backMenuItem = [CCMenuItemImage itemWithNormalImage:@"ReturnArrow.png" selectedImage:@"ReturnArrow.png" block:^(id sender){
        if ([_scrollView didDragSignificantDistance])
        {
            return;
        }

		[_game replaceState:[LevelThemeSelectMenuState stateWithPreselectedTheme:_theme zoomOut:TRUE]];
	}];
	[backMenuItem setPosition:CGPointMake(2.0f, 2.0f)];
	[backMenuItem setAnchorPoint:CGPointMake(0.0f, 0.0f)];
	[backMenu setPosition:CGPointZero];
	[backMenu addChild:backMenuItem];
	[self addChild:backMenu];
}

-(void) dealloc
{
	[_theme release];
	[_scrollView release];
	
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

	[GameStateUtils replaceWithGameplayState:levelName game:_game];
}

@end
