//
//  InputSystem.h
//  Beezle
//
//  Created by Me on 10/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EntitySystem.h"

@class InputAction;

@interface InputSystem : EntitySystem
{
    NSMutableArray *_inputActions;
}

-(void) pushInputAction:(InputAction *)inputAction;
-(InputAction *) peekInputAction;
-(InputAction *) popInputAction;
-(BOOL) hasInputActions;

@end
