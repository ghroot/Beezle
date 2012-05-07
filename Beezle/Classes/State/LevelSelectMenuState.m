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

-(void) createMenu;
-(void) createLevelMenuItems;
-(void) startGame:(id)sender;
-(void) goBack:(id)sender;

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
	
	[self createMenu];
	
	NSString *pollenString = [NSString stringWithFormat:@"Pollen: %d", [[PlayerInformation sharedInformation] totalNumberOfPollen]];
	CCLabelTTF *pollenLabel = [CCLabelTTF labelWithString:pollenString fontName:@"Marker Felt" fontSize:14.0f];
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	[pollenLabel setPosition:CGPointMake(winSize.width, 0.0f)];
	[pollenLabel setAnchorPoint:CGPointMake(1.0f, 0.0f)];
	[self addChild:pollenLabel];
}

-(void) dealloc
{
	[_theme release];
	
	[super dealloc];
}

-(void) createMenu
{
	_menu = [CCMenu menuWithItems:nil];
	
    [self createLevelMenuItems];
	
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

-(void) createLevelMenuItems
{
	NSArray *levelNames = [[LevelOrganizer sharedOrganizer] levelNamesInTheme:_theme];
	for (NSString *levelName in levelNames)
	{
		LevelSelectMenuItem *levelMenuItem = [LevelSelectMenuItem itemWithLevelName:levelName target:self selector:@selector(startGame:)];
#ifndef DEBUG
        [levelMenuItem setIsEnabled:[[PlayerInformation sharedInformation] canPlayLevel:levelName]];
#endif
		[_menu addChild:levelMenuItem];
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
