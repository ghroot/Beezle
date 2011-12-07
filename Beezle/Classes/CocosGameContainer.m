//
//  CocosGameContainer.h
//  Beezle
//
//  Created by Me on 23/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CocosGameContainer.h"
#import "CocosGameState.h"
#import "CocosStateBasedGame.h"
#import "ForwardLayer.h"

@implementation CocosGameContainer

-(void) setup
{
    // Default empty scene
	CCScene *defaultScene = [[[CCScene alloc] init] autorelease];
	[[CCDirector sharedDirector] runWithScene:defaultScene];
    
    [super setup];
    
    // Link all states' selectors to this container
    CocosStateBasedGame *cocosStateBasedGame = (CocosStateBasedGame *)_game;
    for (CocosGameState *cocosGameState in [cocosStateBasedGame states])
    {
        ForwardLayer *forwardLayer = [cocosGameState layer];
        [forwardLayer setTarget:self];
        [forwardLayer setUpdateSelector:@selector(onUpdate:)];
        [forwardLayer setDrawSelector:@selector(onDraw)];
        [forwardLayer setTouchBeganSelector:@selector(onTouchBegan:)];
        [forwardLayer setTouchMovedSelector:@selector(onTouchMoved:)];
        [forwardLayer setTouchEndedSelector:@selector(onTouchEnded:)];
    }
}

-(void) startInterval
{
    [[CCDirector sharedDirector] setAnimationInterval:_updateInterval];
}

-(void) onUpdate:(NSNumber *)delta
{
    [self update:[delta intValue]];
}

-(void) onDraw
{
    [self render];
}

-(void) onTouchBegan:(Touch *)touch
{
    [self touchBegan:touch];
}

-(void) onTouchMoved:(Touch *)touch
{
    [self touchMoved:touch];
}

-(void) onTouchEnded:(Touch *)touch
{
    [self touchEnded:touch];
}

@end
