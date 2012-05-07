//
//  LevelRatings.m
//  Beezle
//
//  Created by KM Lagerstrom on 07/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LevelRatings.h"
#import "AppDelegate.h"
#import "EmailInfo.h"
#import "LevelLayout.h"
#import "LevelLayoutCache.h"
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
			int levelVersion = [[ratingDict objectForKey:@"levelVersion"] intValue];
			int numberOfStars = [[ratingDict objectForKey:@"rating"] intValue];
			[_ratings addObject:[LevelRating ratingWithLevelName:levelName levelVersion:levelVersion numberOfStars:numberOfStars]];
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
	
	NSString *udid = [[UIDevice currentDevice] uniqueIdentifier];
	[dict setObject:udid forKey:@"udid"];
	
	NSMutableArray *array = [NSMutableArray array];
	for (LevelRating *rating in _ratings)
	{
		NSMutableDictionary *ratingDict = [NSMutableDictionary dictionary];
		[ratingDict setObject:[rating levelName] forKey:@"levelName"];
		[ratingDict setObject:[NSNumber numberWithInt:[rating levelVersion]] forKey:@"levelVersion"];
		[ratingDict setObject:[NSNumber numberWithInt:[rating numberOfStars]] forKey:@"rating"];
		[array addObject:ratingDict];
	}
	[dict setObject:array forKey:@"ratings"];
	
	return dict;
}

-(LevelRating *) ratingForLevel:(NSString *)levelName
{
	for (LevelRating *rating in _ratings)
	{
		if ([[rating levelName] isEqualToString:levelName])
		{
			return rating;
		}
	}
	return nil;
}

-(BOOL) hasRatedLevel:(NSString *)levelName withVersion:(int)levelVersion
{
	LevelRating *rating = [self ratingForLevel:levelName];
	return [rating levelVersion] >= levelVersion;
}

-(void) rate:(NSString *)levelName numberOfStars:(int)numberOfStars
{
	LevelLayout *levelLayout = [[LevelLayoutCache sharedLevelLayoutCache] levelLayoutByName:levelName];
	LevelRating *rating = [self ratingForLevel:levelName];
	if (rating != nil)
	{
		[rating setLevelVersion:[levelLayout version]];
		[rating setNumberOfStars:numberOfStars];
	}
	else
	{
		[_ratings addObject:[LevelRating ratingWithLevelName:levelName levelVersion:[levelLayout version] numberOfStars:numberOfStars]];
	}
}

-(void) send
{
	EmailInfo *emailInfo = [[EmailInfo alloc] init];
	[emailInfo setSubject:@"Beezle Level Ratings"];
	[emailInfo setTo:@"marcus.lagerstrom@gmail.com"];
	
	// Message
	[emailInfo setMessage:@"Here are my level ratings! :)"];
	
	// Attachments
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, TRUE);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *fileName = @"Level-Ratings.plist";
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
	if (dict != nil)
	{
		NSString *errorString = nil;
		NSData *data = [NSPropertyListSerialization dataFromPropertyList:dict format:NSPropertyListXMLFormat_v1_0 errorDescription:&errorString];
		[emailInfo addAttachment:@"Level-Ratings.plist" data:data];
	}
	
	[(AppDelegate *)[[UIApplication sharedApplication] delegate] sendEmail:emailInfo];
	[emailInfo release];
}

@end
