//
//  CocosGameContainer.h
//  Beezle
//
//  Created by Me on 23/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CocosGameContainer.h"
#import "ForwardNode.h"

@interface CocosGameContainer()

-(void) addForwardNodeToScene;
-(void) removeForwardNodeFromScene;

@end

@implementation CocosGameContainer

-(id) initWithGame:(Game *)game
{
    if (self = [super initWithGame:game])
    {
        _forwardNode = [[ForwardNode alloc] init];
    }
    return self;
}

-(void) dealloc
{
    [_forwardNode release];
    
    [super dealloc];
}

-(void) setup
{
	// This assumes CCDirector retains the default scene
	CCScene *defaultScene = [[[CCScene alloc] init] autorelease];
	[[CCDirector sharedDirector] runWithScene:defaultScene];

    [super setup];
}

-(void) startInterval
{
    [[CCDirector sharedDirector] setAnimationInterval:_updateInterval];
    
    [_forwardNode setTarget:self];
    [_forwardNode setUpdateSelector:@selector(onUpdate:)];
    [_forwardNode setDrawSelector:@selector(onDraw)];
    [_forwardNode setTouchBeganSelector:@selector(onTouchBegan:)];
    [_forwardNode setTouchMovedSelector:@selector(onTouchMoved:)];
    [_forwardNode setTouchEndedSelector:@selector(onTouchEnded:)];
}

-(void) addForwardNodeToScene
{
	CCScene *runningScene = [[CCDirector sharedDirector] runningScene];
    [runningScene addChild:_forwardNode];
    [_forwardNode scheduleUpdate];
}

-(void) removeForwardNodeFromScene
{
	CCScene *runningScene = [[CCDirector sharedDirector] runningScene];
    [_forwardNode unscheduleAllSelectors];
    [runningScene removeChild:_forwardNode cleanup:TRUE];
}

-(void) setScene:(CCScene *)scene keepCurrent:(BOOL)keepCurrent
{
    [self removeForwardNodeFromScene];
	if (keepCurrent)
	{
		[[CCDirector sharedDirector] pushScene:scene];
	}
	else
	{
		[[CCDirector sharedDirector] replaceScene:scene];
	}
    [self addForwardNodeToScene];
}

-(void) gotoPreviousScene
{
	[self removeForwardNodeFromScene];
	[[CCDirector sharedDirector] popScene];
	[self addForwardNodeToScene];
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
