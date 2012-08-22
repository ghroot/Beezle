//
//  LevelSelectMenuState.m
//  Beezle
//
//  Created by Me on 02/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LevelSelectMenuState.h"
#import "Game.h"
#import "GameplayState.h"
#import "CCBReader.h"
#import "PlayerInformation.h"
#import "LevelThemeSelectMenuState.h"
#import "ScrollView.h"
#import "SoundManager.h"
#import "LevelLayout.h"
#import "LevelLayoutCache.h"
#import "TutorialStripDescription.h"
#import "TutorialOrganizer.h"
#import "LevelOrganizer.h"
#import "TutorialStripMenuState.h"

@interface LevelSelectMenuState()

-(void) addBackground;
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

    [self addBackground];
    [self addInterfaceLevelsMenu];
	[self createBackMenu];
}

-(void) addBackground
{
    CCSprite *backgroundSprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"Colour-%@.jpg", _theme]];
	[backgroundSprite setAnchorPoint:CGPointMake(0.0f, 0.0f)];
	[self addChild:backgroundSprite];
}

-(void) addInterfaceLevelsMenu
{
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
        
        NSString *levelString = [NSString stringWithFormat:@"%d", [menuItemImage tag]];
        CCLabelAtlas *label = [[[CCLabelAtlas alloc] initWithString:levelString charMapFile:@"numberImages.png" itemWidth:25 itemHeight:30 startCharMap:'/'] autorelease];
        [label setAnchorPoint:CGPointMake(0.5f, 0.5f)];
        [label setPosition:[menuItemImage position]];
        [draggableNode addChild:label];
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		[draggableNode setContentSize:CGSizeMake(1200.0f, winSize.height)];
    }

	_scrollView = [[ScrollView alloc] initWithContent:draggableNode];
	[self addChild:_scrollView];
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

		[_game popState];

		LevelThemeSelectMenuState *levelThemeSelectMenuState = (LevelThemeSelectMenuState *)[_game currentState];
		[levelThemeSelectMenuState resetCurrentLevelThemeSelectLayer];
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

	TutorialStripDescription *tutorialStripDescription = [[TutorialOrganizer sharedOrganizer] tutorialStripDescriptionForLevel:levelName];
	if (tutorialStripDescription != nil &&
		![[PlayerInformation sharedInformation] hasSeenTutorialId:[tutorialStripDescription id]])
	{
		NSString *theme = [[LevelOrganizer sharedOrganizer] themeForLevel:levelName];
		TutorialStripMenuState *tutorialStripMenuState = [[[TutorialStripMenuState alloc] initWithFileName:[tutorialStripDescription fileName] theme:theme block:^{
			[_game clearAndReplaceState:[GameplayState stateWithLevelName:levelName]];
		}] autorelease];
		[_game pushState:tutorialStripMenuState];

		[[PlayerInformation sharedInformation] markTutorialIdAsSeenAndSave:[tutorialStripDescription id]];
	}
    else
	{
		[_game clearAndReplaceState:[GameplayState stateWithLevelName:levelName]];
	}
}

@end
