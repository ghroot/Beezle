//
//  LevelRating.m
//  Beezle
//
//  Created by KM Lagerstrom on 07/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LevelRating.h"

@implementation LevelRating

@synthesize levelName = _levelName;
@synthesize levelVersion = _levelVersion;
@synthesize numberOfStars = _numberOfStars;

+(id) ratingWithLevelName:(NSString *)levelName levelVersion:(int)levelVersion numberOfStars:(int)numberOfStars
{
	return [[[self alloc] initWithLevelName:levelName levelVersion:levelVersion numberOfStars:numberOfStars] autorelease];
}

-(id) initWithLevelName:(NSString *)levelName levelVersion:(int)levelVersion numberOfStars:(int)numberOfStars
{
	if (self = [super init])
	{
		_levelName = [levelName retain];
		_levelVersion = levelVersion;
		_numberOfStars = numberOfStars;
	}
	return self;
}

-(void) dealloc
{
	[_levelName release];
	
	[super dealloc];
}

@end
