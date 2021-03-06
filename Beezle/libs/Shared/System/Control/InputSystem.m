//
//  InputSystem.m
//  Beezle
//
//  Created by Me on 10/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "InputSystem.h"
#import "InputAction.h"

static const int DISTANCE_FROM_EDGE_FOR_TOUCH_CANCEL = 8;

@interface InputSystem()

-(void) startListeningForTouches;
-(void) stopListeningForTouches;
-(BOOL) isTouchAtEdgeOfScreen:(UITouch *)touch;
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
	[self clearInputActions];
    [self stopListeningForTouches];
}

-(void) activate
{
	[super activate];
    [self startListeningForTouches];
}

-(void) startListeningForTouches
{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:TRUE];
}

-(void) stopListeningForTouches
{
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
}

-(InputAction *) popInputAction
{
    InputAction *nextInputAction = [[[_inputActions objectAtIndex:0] retain] autorelease];
    [_inputActions removeObjectAtIndex:0];
	return nextInputAction;
}

-(BOOL) hasInputActions
{
    return [_inputActions count] > 0;
}

-(void) clearInputActions
{
	[_inputActions removeAllObjects];
}

-(void) pushInputAction:(InputAction *)inputAction
{
    [_inputActions addObject:inputAction];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint location = [touch locationInView: [touch view]];
	CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL:location];
	InputAction *inputAction = [[[InputAction alloc] initWithTouchType:TOUCH_BEGAN andTouchLocation:convertedLocation] autorelease];
	[self pushInputAction:inputAction];

	return TRUE;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint location = [touch locationInView:[touch view]];
	CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL:location];
	InputAction *inputAction = [[[InputAction alloc] initWithTouchType:TOUCH_MOVED andTouchLocation:convertedLocation] autorelease];
	[self pushInputAction:inputAction];
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ([self isTouchAtEdgeOfScreen:touch])
    {
        [self ccTouchCancelled:touch withEvent:event];
    }
    else
    {
        CGPoint location = [touch locationInView:[touch view]];
        CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL:location];
        InputAction *inputAction = [[[InputAction alloc] initWithTouchType:TOUCH_ENDED andTouchLocation:convertedLocation] autorelease];
        [self pushInputAction:inputAction];
    }
}

-(BOOL) isTouchAtEdgeOfScreen:(UITouch *)touch
{
    CGPoint location = [touch locationInView:[touch view]];
    if (location.x <= DISTANCE_FROM_EDGE_FOR_TOUCH_CANCEL ||
        location.x >= [[touch view] frame].size.width - DISTANCE_FROM_EDGE_FOR_TOUCH_CANCEL ||
        location.y <= DISTANCE_FROM_EDGE_FOR_TOUCH_CANCEL ||
        location.y >= [[touch view] frame].size.height - DISTANCE_FROM_EDGE_FOR_TOUCH_CANCEL)
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [touch locationInView:[touch view]];
	CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL: location];
	InputAction *inputAction = [[[InputAction alloc] initWithTouchType:TOUCH_CANCELLED andTouchLocation:convertedLocation] autorelease];
	[self pushInputAction:inputAction];
}

@end
