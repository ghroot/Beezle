//
//  LevelLayout.m
//  Beezle
//
//  Created by Me on 03/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "LevelLayout.h"

@implementation LevelLayout

@synthesize entries = _entries;

-(id) init
{
    if (self = [super init])
    {
        _entries = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void) dealloc
{
    [_entries release];
    
    [super dealloc];
}

-(void) addLevelLayoutEntry:(LevelLayoutEntry *)entry
{
    [_entries addObject:entry];
}

@end
