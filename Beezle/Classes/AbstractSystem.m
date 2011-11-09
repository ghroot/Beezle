//
//  AbstractSystem.m
//  Beezle
//
//  Created by Me on 08/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AbstractSystem.h"

@implementation AbstractSystem

-(id) init
{
    if (self = [super init])
    {
        _entities = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void) entityAdded:(Entity *)entity
{
    [_entities addObject:entity];
}

-(void) update
{
}

@end
