//
//  ForwardLayer.m
//  Beezle
//
//  Created by Me on 23/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ForwardLayer.h"

@implementation ForwardLayer

-(void) setUpdateTarget:(id)target withSelector:(SEL)selector
{
    _updateTarget = target;
    _updateSelector = selector;
}

-(void) setDrawTarget:(id)target withSelector:(SEL)selector
{
    _drawTarget = target;
    _drawSelector = selector;
}

-(void) update:(ccTime)delta
{
    if (_updateTarget != nil)
    {
        [_updateTarget performSelector:_updateSelector withObject:[NSNumber numberWithFloat:delta]];
    }
}

-(void) draw
{
    if (_drawTarget != nil)
    {
        [_drawTarget performSelector:_drawSelector];
    }
}

@end
