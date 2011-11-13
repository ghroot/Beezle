//
//  BoundryComponent.m
//  Beezle
//
//  Created by Me on 13/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BoundryComponent.h"

@implementation BoundryComponent

@synthesize boundry = _boundry;

-(id) initWithBoundry:(Boundry *)boundry
{
    if (self = [super init])
    {
        _boundry = [boundry retain];
    }
    return self;
}

@end
