//
//  DragComponent.m
//  Beezle
//
//  Created by Me on 13/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DragComponent.h"

@implementation DragComponent

@synthesize dragStartLocation = _dragStartLocation;
@synthesize scale = _scale;

-(id) initWithScale:(float)scale
{
    if (self = [super init])
    {
        _scale = scale;
    }
    return self;
}

@end
