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
	int _numberOfStars;
}

@property (nonatomic, readonly) NSString *levelName;
@property (nonatomic, readonly) int numberOfStars;

+(id) ratingWithLevelName:(NSString *)levelName numberOfStars:(int)numberOfStars;

-(id) initWithLevelName:(NSString *)levelName numberOfStars:(int)numberOfStars;

@end
