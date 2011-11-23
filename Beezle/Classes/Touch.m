//
//  TouchLocation.m
//  Beezle
//
//  Created by Me on 23/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Touch.h"

@implementation Touch

@synthesize point = _point;

-(id) initWithPoint:(CGPoint)point
{
    if (self = [super init])
    {
        _point = point;
    }
    return self;
}

@end
