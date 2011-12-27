//
//  LevelLayout.h
//  Beezle
//
//  Created by Me on 03/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

@class LevelLayoutEntry;

@interface LevelLayout : NSObject
{
	NSString *_levelName;
	int _version;
    NSMutableArray *_entries;
}

@property (nonatomic, retain) NSString *levelName;
@property (nonatomic) int version;
@property (nonatomic, readonly) NSArray *entries;

-(id) initWithLevelName:(NSString *)levelName;

-(void) addLevelLayoutEntry:(LevelLayoutEntry *)entry;

@end
