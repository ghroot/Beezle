//
//  LevelRatings.h
//  Beezle
//
//  Created by KM Lagerstrom on 07/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@class LevelRating;

@interface LevelRatings : NSObject
{
	NSMutableArray *_ratings;
}

@property (nonatomic, readonly) NSArray *ratings;

+(LevelRatings *) sharedRatings;

-(void) save;
-(void) reset;
-(LevelRating *) ratingForLevel:(NSString *)levelName;
-(BOOL) hasRatedLevel:(NSString *)levelName withVersion:(int)levelVersion;
-(void) rate:(NSString *)levelName numberOfStars:(int)numberOfStars;

@end
