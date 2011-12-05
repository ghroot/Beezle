//
//  CocosGameContainer.h
//  Beezle
//
//  Created by Me on 23/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CocosGameContainer.h"
#import "ForwardNode.h"

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

-(void) setScene:(CCScene *)scene
{
    if (_currentScene == nil)
    {
        [[CCDirector sharedDirector] runWithScene:scene];
    }
    else
    {
        [_forwardNode unscheduleAllSelectors];
        [_currentScene removeChild:_forwardNode cleanup:TRUE];
        [[CCDirector sharedDirector] replaceScene:scene];
    }
    [scene addChild:_forwardNode];
    [_forwardNode scheduleUpdate];
    _currentScene = scene;
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
