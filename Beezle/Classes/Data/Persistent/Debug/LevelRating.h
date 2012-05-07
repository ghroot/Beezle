//
//  LevelRating.h
//  Beezle
//
//  Created by KM Lagerstrom on 07/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@interface LevelRating : NSObject
{
	NSString *_levelName;
	int _levelVersion;
	int _numberOfStars;
}

@property (nonatomic, readonly) NSString *levelName;
@property (nonatomic) int levelVersion;
@property (nonatomic) int numberOfStars;

+(id) ratingWithLevelName:(NSString *)levelName levelVersion:(int)levelVersion numberOfStars:(int)numberOfStars;

-(id) initWithLevelName:(NSString *)levelName levelVersion:(int)levelVersion numberOfStars:(int)numberOfStars;

@end
