//
//  InputSystem.m
//  Beezle
//
//  Created by Me on 10/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "InputSystem.h"

@implementation InputSystem

@synthesize touchType = _touchType;
@synthesize touchLocation = _touchLocation;

-(void) reset
{
    _touchType = TOUCH_NONE;
}

@end
