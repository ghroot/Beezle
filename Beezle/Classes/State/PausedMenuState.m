//
//  IngameMenuState.m
//  Beezle
//
//  Created by Me on 06/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PausedMenuState.h"
#import "EditState.h"
#import "Game.h"
#import "GameplayState.h"
#import "LevelLayout.h"
#import "LevelLayoutCache.h"
#import "LevelOrganizer.h"
#import "MainMenuState.h"
#import "LevelSession.h"
#import "Utils.h"
#import "PausedDialog.h"

@interface PausedMenuState()

-(void) editGame:(id)sender;
-(void) gotoMainMenu:(id)sender;

@end

@implementation PausedMenuState

-(id) initWithBackground:(CCNode *)backgroundNode andLevelSession:(LevelSession *)levelSession
{
	if (self = [super init])
	{
		[backgroundNode setPosition:[Utils screenCenterPosition]];
		[self addChild:backgroundNode];

		PausedDialog *pausedDialog = [[[PausedDialog alloc] initWithState:self andLevelSession:levelSession] autorelease];
		[self addChild:pausedDialog];
	}
	return self;
}

-(void) initialise
{
	[super initialise];
	
	_menu = [CCMenu menuWithItems:nil];
    CCMenuItem *editMenuItem = [CCMenuItemFont itemWithString:@"Edit" target:self selector:@selector(editGame:)];
    [_menu addChild:editMenuItem];
	CCMenuItem *nextLevelMenuItem = [CCMenuItemFont itemWithString:@"Next Level" target:self selector:@selector(nextLevel)];
	[_menu addChild:nextLevelMenuItem];
	CCMenuItem *quitMenuItem = [CCMenuItemFont itemWithString:@"Quit" target:self selector:@selector(gotoMainMenu:)];
	[_menu addChild:quitMenuItem];
	[_menu alignItemsVerticallyWithPadding:30.0f];
	[self addChild:_menu];
	
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	GameplayState *gameplayState = (GameplayState *)[_game previousState];
	LevelLayout *levelLayout = [[LevelLayoutCache sharedLevelLayoutCache] levelLayoutByName:[gameplayState levelName]];
	NSString *levelInfoString = [NSString stringWithFormat:@"%@v%d%@", [levelLayout levelName], [levelLayout version], ([levelLayout isEdited] ? @" (edited)" : @"")];
	CCLabelTTF *levelInfoLabel = [CCLabelTTF labelWithString:levelInfoString fontName:@"Marker Felt" fontSize:14.0f];
	[levelInfoLabel setPosition:CGPointMake(winSize.width, 0.0f)];
	[levelInfoLabel setAnchorPoint:CGPointMake(1.0f, 0.0f)];
	[self addChild:levelInfoLabel];
}

-(void) resumeGame
{
	// This assumes the previous state was the game play state
	[_game popState];
}

-(void) restartGame
{
	// This assumes the previous state was the game play state
	[_game popState];
	GameplayState *gameplayState = (GameplayState *)[_game currentState];
	[_game replaceState:[GameplayState stateWithLevelName:[gameplayState levelName]]];
}

-(void) editGame:(id)sender
{
	// This assumes the previous state was the game play state
	[_game popState];
	GameplayState *gameplayState = (GameplayState *)[_game currentState];
	[_game replaceState:[EditState stateWithLevelName:[gameplayState levelName]]];
}

-(void) nextLevel
{
	// This assumes the previous state was the game play state
	[_game popState];
	GameplayState *gameplayState = (GameplayState *)[_game currentState];
	NSString *nextLevelName = [[LevelOrganizer sharedOrganizer] levelNameAfter:[gameplayState levelName]];
    if (nextLevelName != nil)
    {
        [_game replaceState:[GameplayState stateWithLevelName:nextLevelName]];
    }
    else
    {
		[_game replaceState:[MainMenuState state]];
    }
}

-(void) gotoMainMenu:(id)sender
{
	[_game clearAndReplaceState:[MainMenuState state]];
}

@end
