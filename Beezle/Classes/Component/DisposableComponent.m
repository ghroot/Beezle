//
//  DisposableComponent.m
//  Beezle
//
//  Created by Me on 11/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DisposableComponent.h"

@implementation DisposableComponent

@synthesize isDisposed = _isDisposed;

-(id) init
{
    if (self = [super init])
    {
        _isDisposed = FALSE;
    }
    return self;
}

@end
