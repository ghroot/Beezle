//
//  Game.m
//  Beezle
//
//  Created by Me on 07/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Game.h"

@implementation Game

-(void) startWithState:(GameState *)gameState
{
	[gameState setGame:self];
	[[CCDirector sharedDirector] runWithScene:gameState];
}

-(void) replaceState:(GameState *)gameState
{
	[gameState setGame:self];
	[[CCDirector sharedDirector] replaceScene:gameState];
}

-(void) pushState:(GameState *)gameState
{
	[gameState setGame:self];
	[[CCDirector sharedDirector] pushScene:gameState];
}

-(void) popState
{
	[[CCDirector sharedDirector] popScene];
}

-(void) popAndReplaceState:(GameState *)gameState
{
	[gameState setGame:self];
	[[CCDirector sharedDirector] popScene];
	[[CCDirector sharedDirector] replaceScene:gameState];
}

@end
