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
@synthesize scale = _scale;

+(id) componentWithPosition:(CGPoint)position
{
	return [[[self alloc] initWithPosition:position] autorelease];
}

-(id) initWithPosition:(CGPoint)position
{
    if (self = [super init])
    {
        _position = position;
        _rotation = 0.0f;
        _scale = CGPointMake(1.0f, 1.0f);
    }
    return self;
}

-(id) init
{
	return [self initWithPosition:CGPointZero];
}

@end
