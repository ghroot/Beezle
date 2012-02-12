//
//  InputSystem.m
//  Beezle
//
//  Created by Me on 10/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "InputSystem.h"
#import "InputAction.h"
#import "TouchTypes.h"

@interface InputSystem()

-(void) startListeningForTouches;
-(void) stopListeningForTouches;
-(void) pushInputAction:(InputAction *)inputAction;

@end

@implementation InputSystem

-(id) init
{
    if (self = [super init])
    {
        _inputActions = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void) dealloc
{
    [_inputActions release];
    
    [super dealloc];
}

-(void) deactivate
{
	[super deactivate];
    [self stopListeningForTouches];
}

-(void) activate
{
	[super activate];
    [self startListeningForTouches];
}

-(void) startListeningForTouches
{
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:TRUE];
}

-(void) stopListeningForTouches
{
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
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

-(void) pushInputAction:(InputAction *)inputAction
{
    if ([inputAction touchType] == TOUCH_MOVED && [_inputActions count] > 0)
    {
        InputAction *lastInputAction = (InputAction *)[_inputActions lastObject];
        if (lastInputAction.touchType == TOUCH_MOVED)
        {
            [_inputActions removeLastObject];
        }
    }
    [_inputActions addObject:inputAction];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint location = [touch locationInView: [touch view]];
	CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL: location];
	InputAction *inputAction = [[[InputAction alloc] initWithTouchType:TOUCH_BEGAN andTouchLocation:convertedLocation] autorelease];
	[self pushInputAction:inputAction];
	
	return TRUE;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint location = [touch locationInView: [touch view]];
	CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL: location];
	InputAction *inputAction = [[[InputAction alloc] initWithTouchType:TOUCH_MOVED andTouchLocation:convertedLocation] autorelease];
	[self pushInputAction:inputAction];
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint location = [touch locationInView: [touch view]];
	CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL: location];
	InputAction *inputAction = [[[InputAction alloc] initWithTouchType:TOUCH_ENDED andTouchLocation:convertedLocation] autorelease];
	[self pushInputAction:inputAction];
}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
	[self ccTouchEnded:touch withEvent:event];
}

@end
