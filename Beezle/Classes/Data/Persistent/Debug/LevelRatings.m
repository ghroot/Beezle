//
//  LevelRatings.m
//  Beezle
//
//  Created by KM Lagerstrom on 07/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LevelRatings.h"
#import "LevelRating.h"

@interface LevelRatings()

-(void) load;
-(NSDictionary *) getRatingsAsDictionary;

@end

@implementation LevelRatings

@synthesize ratings = _ratings;

+(LevelRatings *) sharedRatings
{
    static LevelRatings *ratings = 0;
    if (!ratings)
    {
        ratings = [[self alloc] init];
    }
    return ratings;
}

-(id) init
{
	if (self = [super init])
	{
		_ratings = [NSMutableArray new];
		[self load];
	}
	return self;
}

-(void) dealloc
{
	[_ratings release];
	
	[super dealloc];
}

-(void) save
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, TRUE);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *fileName = @"Level-Ratings.plist";
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
	BOOL success = [[self getRatingsAsDictionary] writeToFile:filePath atomically:TRUE];
	if (!success)
	{
		NSLog(@"Level ratings failed to save...");
	}
}

-(void) load
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, TRUE);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *fileName = @"Level-Ratings.plist";
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
	if (dict != nil)
	{
		NSArray *ratings = [dict objectForKey:@"ratings"];
		for (NSDictionary *ratingDict in ratings)
		{
			NSString *levelName = [ratingDict objectForKey:@"levelName"];
			int numberOfStars = [[ratingDict objectForKey:@"rating"] intValue];
			[_ratings addObject:[LevelRating ratingWithLevelName:levelName numberOfStars:numberOfStars]];
		}
	}
}

-(void) reset
{
	[_ratings removeAllObjects];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, TRUE);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *fileName = @"Level-Ratings.plist";
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
	[[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
}

-(NSDictionary *) getRatingsAsDictionary
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	
	NSMutableArray *array = [NSMutableArray array];
	for (LevelRating *rating in _ratings)
	{
		NSMutableDictionary *ratingDict = [NSMutableDictionary dictionary];
		[ratingDict setObject:[rating levelName] forKey:@"levelName"];
		[ratingDict setObject:[NSNumber numberWithInt:[rating numberOfStars]] forKey:@"rating"];
		[array addObject:ratingDict];
	}
	[dict setObject:array forKey:@"ratings"];
	
	return dict;
}

-(BOOL) hasRated:(NSString *)levelName
{
	for (LevelRating *rating in _ratings)
	{
		if ([[rating levelName] isEqualToString:levelName])
		{
			return TRUE;
		}
	}
	return FALSE;
}

-(void) rate:(NSString *)levelName numberOfStars:(int)numberOfStars
{
	[_ratings addObject:[LevelRating ratingWithLevelName:levelName numberOfStars:numberOfStars]];
}

@end
