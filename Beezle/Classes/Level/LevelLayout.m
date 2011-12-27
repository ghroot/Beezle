//
//  LevelLayout.m
//  Beezle
//
//  Created by Me on 03/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "LevelLayout.h"

@implementation LevelLayout

@synthesize levelName = _levelName;
@synthesize version = _version;
@synthesize entries = _entries;

// Designated initialiser
-(id) initWithLevelName:(NSString *)levelName
{
	if (self = [super init])
    {
		_levelName = [levelName retain];
		_version = 0;
        _entries = [[NSMutableArray alloc] init];
    }
    return self;
}

-(id) init
{
    return [self initWithLevelName:nil];
}

-(void) dealloc
{
	[_levelName release];
    [_entries release];
    
    [super dealloc];
}

-(void) addLevelLayoutEntry:(LevelLayoutEntry *)entry
{
    [_entries addObject:entry];
}

@end
