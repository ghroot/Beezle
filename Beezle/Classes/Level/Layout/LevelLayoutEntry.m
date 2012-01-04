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
@synthesize position = _position;
@synthesize mirrored = _mirrored;
@synthesize rotation = _rotation;
@synthesize beeTypeAsString = _beeTypeAsString;
@synthesize beeTypesAsStrings = _beeTypesAsStrings;

+(LevelLayoutEntry *) entry
{
	return [[[self alloc] init] autorelease];
}

-(id) init
{
    if (self = [super init])
    {
        _beeTypesAsStrings = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void) dealloc
{
	[_type release];
	[_beeTypeAsString release];
    [_beeTypesAsStrings release];
    
    [super dealloc];
}

-(void) addBeeTypeAsString:(NSString *)beeTypeAsString
{
    [_beeTypesAsStrings addObject:beeTypeAsString];
}

@end
