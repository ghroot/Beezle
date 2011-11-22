//
//  Component.m
//  Beezle
//
//  Created by Me on 06/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Component.h"

@implementation Component

@synthesize enabled = _enabled;

-(id) init
{
    if (self = [super init])
    {
        _enabled = TRUE;
    }
    return self;
}

-(void) enable
{
    _enabled = TRUE;
}

-(void) disable
{
    _enabled = FALSE;
}

@end
