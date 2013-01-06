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
#import "LevelSession.h"
#import "Utils.h"
#import "PausedDialog.h"
#import "PlayState.h"
#import "GameStateUtils.h"
#import "SoundManager.h"
#import "LevelSelectMenuState.h"
#import "SoundButton.h"

@interface PausedMenuState()

-(void) editGame:(id)sender;

@end

@implementation PausedMenuState

-(id) initWithBackground:(CCNode *)backgroundNode andLevelSession:(LevelSession *)levelSession
{
	if (self = [super init])
	{
        _theme = [[[LevelOrganizer sharedOrganizer] themeForLevel:[levelSession levelName]] copy];

        [backgroundNode setPosition:[Utils screenCenterPosition]];
		[self addChild:backgroundNode];

		PausedDialog *pausedDialog = [[[PausedDialog alloc] initWithState:self andLevelSession:levelSession] autorelease];
		[self addChild:pausedDialog];
	}
	return self;
}

-(void) dealloc
{
    [_theme release];

    [super dealloc];
}

-(void) initialise
{
	[super initialise];
	
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	SoundButton *soundButton = [SoundButton node];
	[soundButton setPosition:CGPointMake(winSize.width / 2, 40.0f)];
	[self addChild:soundButton];

#ifdef DEBUG
	CCMenu *menu = [CCMenu menuWithItems:nil];
	CCMenuItem *editMenuItem = [CCMenuItemFont itemWithString:@"Edit" target:self selector:@selector(editGame:)];
	[menu addChild:editMenuItem];
	CCMenuItem *nextLevelMenuItem = [CCMenuItemFont itemWithString:@"Next Level" target:self selector:@selector(nextLevel)];
	[menu addChild:nextLevelMenuItem];
	[menu alignItemsVerticallyWithPadding:30.0f];
	[menu setPosition:CGPointMake([menu position].x, [menu position].y + 50.0f)];
	[self addChild:menu];

	GameplayState *gameplayState = (GameplayState *)[_game previousState];
	LevelLayout *levelLayout = [[LevelLayoutCache sharedLevelLayoutCache] levelLayoutByName:[gameplayState levelName]];
	NSString *levelInfoString = [NSString stringWithFormat:@"%@v%d%@", [levelLayout levelName], [levelLayout version], ([levelLayout isEdited] ? @" (edited)" : @"")];
	CCLabelTTF *levelInfoLabel = [CCLabelTTF labelWithString:levelInfoString fontName:@"Marker Felt" fontSize:14.0f];
	[levelInfoLabel setPosition:CGPointMake(winSize.width, 0.0f)];
	[levelInfoLabel setAnchorPoint:CGPointMake(1.0f, 0.0f)];
	[self addChild:levelInfoLabel];
#endif
}

-(void) enter
{
	[super enter];

	[[SoundManager sharedManager] stopMusic];
}


-(void) resumeGame
{
	// This assumes the previous state was the game play state
	[_game popStateWithTransition:FALSE];
}

-(void) restartGame
{
	// This assumes the previous state was the game play state
	[_game popState];
	GameplayState *gameplayState = (GameplayState *)[_game currentState];
	[_game replaceState:[GameplayState stateWithLevelName:[gameplayState levelName]]];
}

-(void) exitGame
{
    [_game clearAndReplaceState:[LevelSelectMenuState stateWithTheme:_theme]];
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
		[GameStateUtils replaceWithGameplayState:nextLevelName game:_game];
    }
    else
    {
		[_game replaceState:[PlayState state]];
    }
}

@end
