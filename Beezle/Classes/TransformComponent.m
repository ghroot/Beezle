//
//  TransformBehaviour.m
//  Beezle
//
//  Created by Me on 07/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TransformComponent.h"

@implementation TransformComponent

@synthesize position = _position;
@synthesize rotation = _rotation;

-(id) initWithPosition:(CGPoint)position
{
    if (self = [self init])
    {
        _position = position;
        _rotation = 0.0f;
    }
    return self;
}

@end
