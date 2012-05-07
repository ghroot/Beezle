//
//  LevelRatings.h
//  Beezle
//
//  Created by KM Lagerstrom on 07/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@interface LevelRatings : NSObject
{
	NSMutableArray *_ratings;
}

@property (nonatomic, readonly) NSArray *ratings;

+(LevelRatings *) sharedRatings;

-(void) save;
-(void) reset;
-(BOOL) hasRated:(NSString *)levelName;
-(void) rate:(NSString *)levelName numberOfStars:(int)numberOfStars;

@end
