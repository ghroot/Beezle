//
//  LevelLayoutEntry.m
//  Beezle
//
//  Created by Me on 03/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "LevelLayoutEntry.h"

@implementation LevelLayoutEntry

@synthesize type = _type;
@synthesize componentsDict = _componentsDict;

+(LevelLayoutEntry *) entry
{
	return [[[self alloc] init] autorelease];
}

-(id) init
{
    if (self = [super init])
    {
		_componentsDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void) dealloc
{
	[_type release];
	[_componentsDict release];
    
    [super dealloc];
}

@end
