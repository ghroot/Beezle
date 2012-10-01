//
//  LoadingState.m
//  Beezle
//
//  Created by KM Lagerstrom on 03/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoadingState.h"
#import "Game.h"

@implementation LoadingState

+(id) stateWithGameState:(GameState *)gameState
{
	return [[[self alloc] initWithGameState:gameState] autorelease];
}

-(id) initWithGameState:(GameState *)gameState
{
	if (self = [super init])
	{
		_gameStateToLoad = [gameState retain];
	}
	return self;
}

-(void) initialise
{
	[super initialise];
	
	CCLayer *layer = [CCLayer node];
	CCSprite *loadingSprite = [CCSprite spriteWithFile:@"Syst-Text-Loading.png"];
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	[loadingSprite setPosition:CGPointMake(winSize.width / 2, winSize.height / 2)];
	[layer addChild:loadingSprite];
	[self addChild:layer];
}

-(void) dealloc
{
	[_gameStateToLoad release];
	
	[super dealloc];
}

-(void) onEnterTransitionDidFinish
{
	[super onEnterTransitionDidFinish];
	
	_initialiseAndReplaceSceneCountdown = 2;
}

-(void) update:(ccTime)delta
{
	if (_initialiseAndReplaceSceneCountdown > 0)
	{
		_initialiseAndReplaceSceneCountdown--;
		if (_initialiseAndReplaceSceneCountdown == 0)
		{
			[_gameStateToLoad setGame:_game];
			[_gameStateToLoad initialise];
			[_game replaceState:_gameStateToLoad];
		}
	}
}

@end
