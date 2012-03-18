//
//  LevelFailedDialog.m
//  Beezle
//
//  Created by KM Lagerstrom on 08/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LevelFailedDialog.h"
#import "Game.h"
#import "GameplayState.h"

#define IMAGE_PATH @"Bubble.png"

@interface LevelFailedDialog()

-(void) restartLevel:(id)sender;

@end

@implementation LevelFailedDialog

-(id) initWithGame:(Game *)game andLevelName:(NSString *)levelName
{
	if (self = [super initWithImage:IMAGE_PATH])
	{
		_game = game;
		_levelName = levelName;
		
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		
		CCMenuItemFont *menuItemRestart = [CCMenuItemFont itemWithString:@"Try again" target:self selector:@selector(restartLevel:)];
		[menuItemRestart setFontSize:24];
		[menuItemRestart setColor:ccc3(0, 0, 0)];
		[menuItemRestart setPosition:CGPointMake(winSize.width / 2, winSize.height / 2)];
		[menuItemRestart setAnchorPoint:CGPointMake(0.5f, 0.5f)];
		CCMenu *menu = [CCMenu menuWithItems:menuItemRestart, nil];
		[menu setPosition:CGPointZero];
		[_imageSprite addChild:menu];
	}
	return self;
}

-(void) restartLevel:(id)sender
{
	[_game replaceState:[GameplayState stateWithLevelName:_levelName]];
}

@end
