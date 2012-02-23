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
	BOOL _didCollectKey;
	BOOL _didUseKey;
}

@property (nonatomic, readonly) NSString *levelName;
@property (nonatomic, readonly) int numberOfCollectedPollen;
@property (nonatomic, readonly) BOOL didCollectKey;
@property (nonatomic) BOOL didUseKey;

-(id) initWithLevelName:(NSString *)levelName;

-(void) consumedEntity:(Entity *)entity;

@end
