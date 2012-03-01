//
//  InputSystem.h
//  Beezle
//
//  Created by Me on 10/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EntitySystem.h"
#import "cocos2d.h"

@class InputAction;

@interface InputSystem : EntitySystem <CCTargetedTouchDelegate>
{
    NSMutableArray *_inputActions;
}

-(InputAction *) popInputAction;
-(BOOL) hasInputActions;
-(void) clearInputActions;

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event;
-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event;
-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event;
-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event;

@end
