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
#import "MainMenuState.h"

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
	}
    return self;
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
	[_game clearAndReplaceState:[MainMenuState state]];
}

@end
