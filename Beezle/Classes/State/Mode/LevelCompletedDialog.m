//
//  LevelCompletedDialog.m
//  Beezle
//
//  Created by KM Lagerstrom on 09/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LevelCompletedDialog.h"
#import "Game.h"
#import "GameplayState.h"
#import "LevelOrganizer.h"
#import "LevelSession.h"
#import "MainMenuState.h"
#import "PlayerInformation.h"

#define IMAGE_PATH @"Bubble.png"

@interface LevelCompletedDialog()

-(void) loadNextLevel:(id)sender;

@end

@implementation LevelCompletedDialog

-(id) initWithGame:(Game *)game andLevelSession:(LevelSession *)levelSession
{
	if (self = [super initWithImage:IMAGE_PATH])
	{
		_game = game;
		_levelSession = levelSession;
		
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		
		NSString *pollenString = [NSString stringWithFormat:@"Pollen: %d", [levelSession numberOfCollectedPollen]];
		CCLabelTTF *pollenLabel = [CCLabelTTF labelWithString:pollenString fontName:@"Marker Felt" fontSize:24];
		[pollenLabel setPosition:CGPointMake(winSize.width / 2, winSize.height / 2 + 40)];
		[pollenLabel setAnchorPoint:CGPointMake(0.5f, 0.5f)];
		[pollenLabel setColor:ccc3(0, 0, 0)];
		[_imageSprite addChild:pollenLabel];
		
		NSString *unusedBeesString = [NSString stringWithFormat:@"Unused bees: %d", [levelSession numberOfUnusedBees]];
		CCLabelTTF *unusedBeesLabel = [CCLabelTTF labelWithString:unusedBeesString fontName:@"Marker Felt" fontSize:24];
		[unusedBeesLabel setPosition:CGPointMake(winSize.width / 2, winSize.height / 2)];
		[unusedBeesLabel setAnchorPoint:CGPointMake(0.5f, 0.5f)];
		[unusedBeesLabel setColor:ccc3(0, 0, 0)];
		[_imageSprite addChild:unusedBeesLabel];
		
		NSString *totalString = nil;
		if ([[PlayerInformation sharedInformation] isPollenRecord:_levelSession])
		{
			totalString = [NSString stringWithFormat:@"Total: %d (Record!)", [levelSession totalNumberOfPollen]];
		}
		else
		{
			totalString = [NSString stringWithFormat:@"Total: %d", [levelSession totalNumberOfPollen]];
		}
		CCLabelTTF *totalLabel = [CCLabelTTF labelWithString:totalString fontName:@"Marker Felt" fontSize:24];
		[totalLabel setPosition:CGPointMake(winSize.width / 2, winSize.height / 2 - 40)];
		[totalLabel setAnchorPoint:CGPointMake(0.5f, 0.5f)];
		[totalLabel setColor:ccc3(0, 0, 0)];
		[_imageSprite addChild:totalLabel];
		
		CCMenuItemFont *menuItemRestart = [CCMenuItemFont itemWithString:@"Next level" target:self selector:@selector(loadNextLevel:)];
		[menuItemRestart setFontSize:24];
		[menuItemRestart setPosition:CGPointMake(winSize.width / 2, winSize.height / 2 - 80)];
		[menuItemRestart setAnchorPoint:CGPointMake(0.5f, 0.5f)];
		[menuItemRestart setColor:ccc3(0, 0, 0)];
		CCMenu *menu = [CCMenu menuWithItems:menuItemRestart, nil];
		[menu setPosition:CGPointZero];
		[_imageSprite addChild:menu];
	}
	return self;
}

-(void) loadNextLevel:(id)sender
{
    NSString *nextLevelName = [[LevelOrganizer sharedOrganizer] levelNameAfter:[_levelSession levelName]];
    if (nextLevelName != nil)
    {
        [_game replaceState:[GameplayState stateWithLevelName:nextLevelName]];
    }
    else
    {
		[_game replaceState:[MainMenuState state]];
    }
}

@end
