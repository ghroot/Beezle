//
//  ForwardLayer.m
//  Beezle
//
//  Created by Me on 23/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ForwardNode.h"
#import "Touch.h"

@implementation ForwardNode

-(id) init
{
    if (self = [super init])
    {
        self.isTouchEnabled = TRUE;
    }
    return self;
}

-(void) setTarget:(id)target
{
    _target = target;
}

-(void) setUpdateSelector:(SEL)selector
{
    _updateSelector = selector;
}

-(void) setDrawSelector:(SEL)selector
{
    _drawSelector = selector;
}

-(void) setTouchBeganSelector:(SEL)selector
{
    _touchBeganSelector = selector;
}

-(void) setTouchMovedSelector:(SEL)selector
{
    _touchMovedSelector = selector;
}

-(void) setTouchEndedSelector:(SEL)selector
{
    _touchEndedSelector = selector;
}

-(void) update:(ccTime)delta
{
    if (_updateSelector != nil)
    {
        [_target performSelector:_updateSelector withObject:[NSNumber numberWithInt:1000 * delta]];
    }
}

-(void) draw
{
    if (_drawSelector != nil)
    {
        [_target performSelector:_drawSelector];
    }
}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_touchBeganSelector != nil)
    {
        UITouch* touch = [touches anyObject];
        CGPoint location = [touch locationInView: [touch view]];
        CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL: location];
    
        Touch *touchParameter = [[[Touch alloc] initWithPoint:convertedLocation] autorelease];
        [_target performSelector:_touchBeganSelector withObject:touchParameter];
    }
}

-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_touchMovedSelector != nil)
    {
        UITouch* touch = [touches anyObject];
        CGPoint location = [touch locationInView: [touch view]];
        CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL: location];
        
        Touch *touchParameter = [[[Touch alloc] initWithPoint:convertedLocation] autorelease];
        [_target performSelector:_touchMovedSelector withObject:touchParameter];
    }
}

-(void) ccTouchesEnded:(NSSet*)touches withEvent:(UIEvent *)event
{
    if (_touchEndedSelector != nil)
    {
        UITouch* touch = [touches anyObject];
        CGPoint location = [touch locationInView: [touch view]];
        CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL: location];
        
        Touch *touchParameter = [[[Touch alloc] initWithPoint:convertedLocation] autorelease];
        [_target performSelector:_touchEndedSelector withObject:touchParameter];
    }
}

@end
