//
//  EmptyState.m
//  Beezle
//
//  Created by Me on 07/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EmptyState.h"
#import "Game.h"
#import "MainMenuState.h"

@implementation EmptyState

-(id) init
{
    if (self = [super init])
    {
        [[CCDirector sharedDirector] setNeedClear:TRUE];
    }
    return self;
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    [_game replaceState:[MainMenuState state]];
	
	return TRUE;
}

@end
