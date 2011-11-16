//
//  InputAction.m
//  Beezle
//
//  Created by Me on 14/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "InputAction.h"

@implementation InputAction

@synthesize touchType = _touchType;
@synthesize touchLocation = _touchLocation;

-(id) initWithTouchType:(int)touchType andTouchLocation:(CGPoint)touchLocation
{
    if (self = [super init])
    {
        _touchType = touchType;
        _touchLocation = touchLocation;
    }
    return self;
}

@end
