//
//  LevelSession.h
//  Beezle
//
//  Created by KM Lagerstrom on 22/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@interface LevelSession : NSObject
{
	NSString *_levelName;
	int _numberOfCollectedPollen;
	int _numberOfUnusedBees;
}

@property (nonatomic, readonly) NSString *levelName;
@property (nonatomic, readonly) int numberOfCollectedPollen;
@property (nonatomic) int numberOfUnusedBees;

-(id) initWithLevelName:(NSString *)levelName;

-(void) consumedPollenEntity:(Entity *)pollenEntity;
-(int) totalNumberOfPollen;
-(int) totalNumberOfFlowers;

@end
