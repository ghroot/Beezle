//
//  EditIngameMenuState.m
//  Beezle
//
//  Created by Me on 18/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EditIngameMenuState.h"
#import "EditState.h"
#import "Game.h"
#import "GameplayState.h"
#import "LevelLayout.h"
#import "LevelLayoutCache.h"
#import "PlayState.h"

@implementation EditIngameMenuState

-(id) init
{
	if (self = [super init])
	{
		_menu = [CCMenu menuWithItems:nil];
		CCMenuItem *resumeMenuItem = [CCMenuItemFont itemWithString:@"Resume" target:self selector:@selector(resumeGame:)];
		[_menu addChild:resumeMenuItem];
		CCMenuItem *tryMenuItem = [CCMenuItemFont itemWithString:@"Try" target:self selector:@selector(tryGame:)];
		[_menu addChild:tryMenuItem];
		CCMenuItem *saveMenuItem = [CCMenuItemFont itemWithString:@"Save" target:self selector:@selector(saveLevel:)];
		[_menu addChild:saveMenuItem];
		CCMenuItem *resetMenuItem = [CCMenuItemFont itemWithString:@"Reset" target:self selector:@selector(resetLevel:)];
		[_menu addChild:resetMenuItem];
		CCMenuItem *quitMenuItem = [CCMenuItemFont itemWithString:@"Quit" target:self selector:@selector(gotoMainMenu:)];
		[_menu addChild:quitMenuItem];
		[_menu alignItemsVerticallyWithPadding:30.0f];
		[self addChild:_menu];

		_pollenForTwoFlowersLabel = [CCLabelTTF labelWithString:@"2 flowers:" fontName:@"Marker Felt" fontSize:20];
		[_pollenForTwoFlowersLabel setAnchorPoint:CGPointMake(0.0f, 0.5f)];
		[_pollenForTwoFlowersLabel setPosition:CGPointMake(5.0f, 230.0f)];
		[self addChild:_pollenForTwoFlowersLabel];

		CCMenuItemFont *increasePollen5ForTwoFlowersMenuItem = [CCMenuItemFont itemWithString:@"Increase 5" block:^(id sender){
			EditState *editState = (EditState *)[_game previousState];
			[editState setPollenForTwoFlowers:[editState pollenForTwoFlowers] + 5];
			[_pollenForTwoFlowersLabel setString:[NSString stringWithFormat:@"2 flowers: %d", [editState pollenForTwoFlowers]]];
		}];
		[increasePollen5ForTwoFlowersMenuItem setFontSize:20];
		[increasePollen5ForTwoFlowersMenuItem setAnchorPoint:CGPointMake(0.0f, 0.5f)];
		[increasePollen5ForTwoFlowersMenuItem setPosition:CGPointMake(5.0f, 270.0f)];

		CCMenuItemFont *increasePollenForTwoFlowersMenuItem = [CCMenuItemFont itemWithString:@"Increase 1" block:^(id sender){
			EditState *editState = (EditState *)[_game previousState];
			[editState setPollenForTwoFlowers:[editState pollenForTwoFlowers] + 1];
			[_pollenForTwoFlowersLabel setString:[NSString stringWithFormat:@"2 flowers: %d", [editState pollenForTwoFlowers]]];
		}];
		[increasePollenForTwoFlowersMenuItem setFontSize:20];
		[increasePollenForTwoFlowersMenuItem setAnchorPoint:CGPointMake(0.0f, 0.5f)];
		[increasePollenForTwoFlowersMenuItem setPosition:CGPointMake(5.0f, 250.0f)];

		CCMenuItemFont *decreasePollenForTwoFlowersMenuItem = [CCMenuItemFont itemWithString:@"Decrease 1" block:^(id sender){
			EditState *editState = (EditState *)[_game previousState];
			if ([editState pollenForTwoFlowers] > 0)
			{
				[editState setPollenForTwoFlowers:[editState pollenForTwoFlowers] - 1];
				[_pollenForTwoFlowersLabel setString:[NSString stringWithFormat:@"2 flowers: %d", [editState pollenForTwoFlowers]]];
			}
		}];
		[decreasePollenForTwoFlowersMenuItem setFontSize:20];
		[decreasePollenForTwoFlowersMenuItem setAnchorPoint:CGPointMake(0.0f, 0.5f)];
		[decreasePollenForTwoFlowersMenuItem setPosition:CGPointMake(5.0f, 210.0f)];

		CCMenuItemFont *decreasePollen5ForTwoFlowersMenuItem = [CCMenuItemFont itemWithString:@"Decrease 5" block:^(id sender){
			EditState *editState = (EditState *)[_game previousState];
			if ([editState pollenForTwoFlowers] >= 5)
			{
				[editState setPollenForTwoFlowers:[editState pollenForTwoFlowers] - 5];
				[_pollenForTwoFlowersLabel setString:[NSString stringWithFormat:@"2 flowers: %d", [editState pollenForTwoFlowers]]];
			}
		}];
		[decreasePollen5ForTwoFlowersMenuItem setFontSize:20];
		[decreasePollen5ForTwoFlowersMenuItem setAnchorPoint:CGPointMake(0.0f, 0.5f)];
		[decreasePollen5ForTwoFlowersMenuItem setPosition:CGPointMake(5.0f, 190.0f)];

		_pollenForThreeFlowersLabel = [CCLabelTTF labelWithString:@"3 flowers:" fontName:@"Marker Felt" fontSize:20];
		[_pollenForThreeFlowersLabel setAnchorPoint:CGPointMake(0.0f, 0.5f)];
		[_pollenForThreeFlowersLabel setPosition:CGPointMake(5.0f, 90.0f)];
		[self addChild:_pollenForThreeFlowersLabel];

		CCMenuItemFont *increasePollen5ForThreeFlowersMenuItem = [CCMenuItemFont itemWithString:@"Increase 5" block:^(id sender){
			EditState *editState = (EditState *)[_game previousState];
			[editState setPollenForThreeFlowers:[editState pollenForThreeFlowers] + 5];
			[_pollenForThreeFlowersLabel setString:[NSString stringWithFormat:@"3 flowers: %d", [editState pollenForThreeFlowers]]];
		}];
		[increasePollen5ForThreeFlowersMenuItem setFontSize:20];
		[increasePollen5ForThreeFlowersMenuItem setAnchorPoint:CGPointMake(0.0f, 0.5f)];
		[increasePollen5ForThreeFlowersMenuItem setPosition:CGPointMake(5.0f, 130.0f)];

		CCMenuItemFont *increasePollenForThreeFlowersMenuItem = [CCMenuItemFont itemWithString:@"Increase 1" block:^(id sender){
			EditState *editState = (EditState *)[_game previousState];
			[editState setPollenForThreeFlowers:[editState pollenForThreeFlowers] + 1];
			[_pollenForThreeFlowersLabel setString:[NSString stringWithFormat:@"3 flowers: %d", [editState pollenForThreeFlowers]]];
		}];
		[increasePollenForThreeFlowersMenuItem setFontSize:20];
		[increasePollenForThreeFlowersMenuItem setAnchorPoint:CGPointMake(0.0f, 0.5f)];
		[increasePollenForThreeFlowersMenuItem setPosition:CGPointMake(5.0f, 110.0f)];

		CCMenuItemFont *decreasePollenForThreeFlowersMenuItem = [CCMenuItemFont itemWithString:@"Decrease 1" block:^(id sender){
			EditState *editState = (EditState *)[_game previousState];
			if ([editState pollenForThreeFlowers] > 0)
			{
				[editState setPollenForThreeFlowers:[editState pollenForThreeFlowers] - 1];
				[_pollenForThreeFlowersLabel setString:[NSString stringWithFormat:@"3 flowers: %d", [editState pollenForThreeFlowers]]];
			}
		}];
		[decreasePollenForThreeFlowersMenuItem setFontSize:20];
		[decreasePollenForThreeFlowersMenuItem setAnchorPoint:CGPointMake(0.0f, 0.5f)];
		[decreasePollenForThreeFlowersMenuItem setPosition:CGPointMake(5.0f, 70.0f)];

		CCMenuItemFont *decreasePollen5ForThreeFlowersMenuItem = [CCMenuItemFont itemWithString:@"Decrease 5" block:^(id sender){
			EditState *editState = (EditState *)[_game previousState];
			if ([editState pollenForThreeFlowers] >= 5)
			{
				[editState setPollenForThreeFlowers:[editState pollenForThreeFlowers] - 5];
				[_pollenForThreeFlowersLabel setString:[NSString stringWithFormat:@"3 flowers: %d", [editState pollenForThreeFlowers]]];
			}
		}];
		[decreasePollen5ForThreeFlowersMenuItem setFontSize:20];
		[decreasePollen5ForThreeFlowersMenuItem setAnchorPoint:CGPointMake(0.0f, 0.5f)];
		[decreasePollen5ForThreeFlowersMenuItem setPosition:CGPointMake(5.0f, 50.0f)];

		_flowerPollenMenu = [CCMenu menuWithItems:increasePollen5ForTwoFlowersMenuItem, increasePollenForTwoFlowersMenuItem,
						decreasePollenForTwoFlowersMenuItem, decreasePollen5ForTwoFlowersMenuItem, increasePollen5ForThreeFlowersMenuItem,
						increasePollenForThreeFlowersMenuItem, decreasePollenForThreeFlowersMenuItem, decreasePollen5ForThreeFlowersMenuItem, nil];
		[_flowerPollenMenu setAnchorPoint:CGPointZero];
		[_flowerPollenMenu setPosition:CGPointZero];
		[self addChild:_flowerPollenMenu];
	}
    return self;
}

-(void) enter
{
	[super enter];

	EditState *editState = (EditState *)[_game previousState];
	[_pollenForTwoFlowersLabel setString:[NSString stringWithFormat:@"2 flowers: %d", [editState pollenForTwoFlowers]]];
	[_pollenForThreeFlowersLabel setString:[NSString stringWithFormat:@"3 flowers: %d", [editState pollenForThreeFlowers]]];
}


-(void) resumeGame:(id)sender
{
	// This assumes the previous state was the edit state
	[_game popState];
}

-(void) tryGame:(id)sender
{
	// This assumes the previous state was the edit state
	[_game popState];
	EditState *editState = (EditState *)[_game currentState];
	
	// Get version
	NSString *levelName = [editState levelName];
	LevelLayout *levelLayout = [[LevelLayoutCache sharedLevelLayoutCache] levelLayoutByName:levelName];
	int currentVersion = [levelLayout version];
	
	// Create new layout from world
	LevelLayout *newLevelLayout = [LevelLayout layoutWithContentsOfWorld:[editState world] levelName:levelName version:currentVersion];
	[newLevelLayout setIsEdited:TRUE];

	// Flower pollen requirements
	[newLevelLayout setPollenForTwoFlowers:[editState pollenForTwoFlowers]];
	[newLevelLayout setPollenForThreeFlowers:[editState pollenForThreeFlowers]];
	
	// Replace cached version of level layout
	[[LevelLayoutCache sharedLevelLayoutCache] addLevelLayout:newLevelLayout];
	
	[_game replaceState:[GameplayState stateWithLevelName:levelName]];
}

-(void) saveLevel:(id)sender
{
	// This assumes the previous state was the edit state
	[_game popState];
	EditState *editState = (EditState *)[_game currentState];
	
	// Calculate next version
	NSString *levelName = [editState levelName];
	LevelLayout *previousLevelLayout = [[LevelLayoutCache sharedLevelLayoutCache] levelLayoutByName:levelName];
	int nextVersion = [previousLevelLayout version] + 1;
	
	// Create new layout from world
	LevelLayout *newLevelLayout = [LevelLayout layoutWithContentsOfWorld:[editState world] levelName:levelName version:nextVersion];
	[newLevelLayout setIsEdited:TRUE];

	// Flower pollen requirements
	[newLevelLayout setPollenForTwoFlowers:[editState pollenForTwoFlowers]];
	[newLevelLayout setPollenForThreeFlowers:[editState pollenForThreeFlowers]];

	// Replace cached version of level layout
	[[LevelLayoutCache sharedLevelLayoutCache] addLevelLayout:newLevelLayout];
	
	// Save level as dictionary to a file
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, TRUE);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *levelFileName = [NSString stringWithFormat:@"%@-Layout.plist", levelName];
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:levelFileName];
	BOOL success = [[newLevelLayout layoutAsDictionary] writeToFile:filePath atomically:TRUE];
	if (success)
	{
		NSLog(@"%@v%i saved successfully!", levelName, nextVersion);
	}
	else
	{
		NSLog(@"%@ failed to save...", levelName);
	}
}

-(void) resetLevel:(id)sender
{
	// This assumes the previous state was the edit state
	[_game popState];
	EditState *editState = (EditState *)[_game currentState];
	
	// Remove cached level layout
	[[LevelLayoutCache sharedLevelLayoutCache] purgeCachedLevelLayout:[editState levelName]];
	
	// Remove level as dictionary in a file
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, TRUE);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *levelFileName = [NSString stringWithFormat:@"%@-Layout.plist", [editState levelName]];
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:levelFileName];
	[[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
	
	[_game replaceState:[EditState stateWithLevelName:[editState levelName]]];
}

-(void) gotoMainMenu:(id)sender
{
	[_game clearAndReplaceState:[PlayState state]];
}

@end
