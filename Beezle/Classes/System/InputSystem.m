//
//  InputSystem.m
//  Beezle
//
//  Created by Me on 10/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "InputSystem.h"
#import "InputAction.h"

@implementation InputSystem

-(id) init
{
    if (self = [super init])
    {
        _inputActions = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void) pushInputAction:(InputAction *)inputAction
{
    if ([inputAction touchType] == TOUCH_MOVE && [_inputActions count] > 0)
    {
        InputAction *lastInputAction = (InputAction *)[_inputActions lastObject];
        if (lastInputAction.touchType == TOUCH_MOVE)
        {
            [_inputActions removeLastObject];
        }
    }
    
    [_inputActions addObject:inputAction];
}

-(InputAction *) popInputAction
{
    InputAction *nextInputAction = [[[_inputActions objectAtIndex:0] retain] autorelease];
    [_inputActions removeObject:nextInputAction];
    return nextInputAction;
}

-(BOOL) hasInputActions
{
    return [_inputActions count] > 0;
}

-(void) dealloc
{
    [_inputActions release];
    
    [super dealloc];
}

@end
