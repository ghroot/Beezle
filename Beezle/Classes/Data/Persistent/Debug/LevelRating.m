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
@synthesize numberOfStars = _numberOfStars;

+(id) ratingWithLevelName:(NSString *)levelName numberOfStars:(int)numberOfStars
{
	return [[[self alloc] initWithLevelName:levelName numberOfStars:numberOfStars] autorelease];
}

-(id) initWithLevelName:(NSString *)levelName numberOfStars:(int)numberOfStars
{
	if (self = [super init])
	{
		_levelName = [levelName retain];
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
