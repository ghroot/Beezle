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
#import "LevelLayout.h"
#import "LevelLayoutCache.h"
#import "LevelLayoutEntry.h"
#import "LevelOrganizer.h"
#import "LevelSelectMenuItem.h"
#import "PlayerInformation.h"

@interface LevelSelectMenuState()

-(void) createLevelMenuItems;
-(void) createLevelMenuItemsEdit;

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
		_theme = [theme retain];
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
	
	[[CCDirector sharedDirector] setNeedClear:TRUE];
	
	_menu = [CCMenu menuWithItems:nil];
	
	if (CONFIG_CAN_EDIT_LEVELS)
	{
		[self createLevelMenuItemsEdit];
	}
	else
	{
		[self createLevelMenuItems];
	}
	
	CCMenuItemFont *backMenuItem = [CCMenuItemFont itemWithString:@"Back" target:self selector:@selector(goBack:)];
	[backMenuItem setFontSize:24];
	[_menu addChild:backMenuItem];
	
	int nLevels = [[_menu children] count] - 1;
	int nRows = 9;
	int n1 = (int)(nLevels / nRows) + 1;
	int n2 = nLevels - (nRows - 1) * n1;
	[_menu alignItemsInColumns:
		[NSNumber numberWithInt:n1],
		[NSNumber numberWithInt:n1],
		[NSNumber numberWithInt:n1],
		[NSNumber numberWithInt:n1],
		[NSNumber numberWithInt:n1],
		[NSNumber numberWithInt:n1],
		[NSNumber numberWithInt:n1],
		[NSNumber numberWithInt:n1],
		[NSNumber numberWithInt:n2],
		[NSNumber numberWithInt:1],
		nil];
	
	[self addChild:_menu];
}

-(void) dealloc
{
	[_theme release];
	
	[super dealloc];
}

-(void) createLevelMenuItems
{
	NSArray *levelNames = [[LevelOrganizer sharedOrganizer] levelNamesInTheme:_theme];
	for (NSString *levelName in levelNames)
	{
		LevelSelectMenuItem *levelMenuItem = [LevelSelectMenuItem itemWithLevelName:levelName target:self selector:@selector(startGame:)];
		[_menu addChild:levelMenuItem];
	}
}

-(void) createLevelMenuItemsEdit
{
	NSArray *levelNames = [[LevelOrganizer sharedOrganizer] levelNamesInTheme:_theme];
	for (NSString *levelName in levelNames)
	{
		LevelSelectMenuItem *levelMenuItem = [LevelSelectMenuItem itemWithLevelName:levelName target:self selector:@selector(startGame:)];
		[_menu addChild:levelMenuItem];
		
		LevelLayout *levelLayout = [[LevelLayoutCache sharedLevelLayoutCache] levelLayoutByName:levelName];
		if (levelLayout != nil)
		{
			BOOL hasGate = FALSE;
			for (LevelLayoutEntry *levelLayoutEntry in [levelLayout entries])
			{
				if ([[levelLayoutEntry type] isEqualToString:@"CAVEGATE"])
				{
					hasGate = TRUE;
					break;
				}
			}
			if (hasGate)
			{
				NSString *caveLevelName = [NSString stringWithFormat:@"%@-Cave", levelName];
				LevelSelectMenuItem *caveLevelMenuItem = [LevelSelectMenuItem itemWithLevelName:caveLevelName target:self selector:@selector(startGame:)];
				[_menu addChild:caveLevelMenuItem];
			}
		}
	}
}

-(void) startGame:(id)sender
{
	LevelSelectMenuItem *levelMenuItem = (LevelSelectMenuItem *)sender;
	[_game clearAndReplaceState:[GameplayState stateWithLevelName:[levelMenuItem levelName]]];
}

-(void) goBack:(id)sender
{
	[_game popState];
}

@end
