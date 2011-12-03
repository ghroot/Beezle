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
    NSMutableArray *_entries;
}

@property (nonatomic, readonly) NSArray *entries;

-(void) addLevelLayoutEntry:(LevelLayoutEntry *)entry;

@end
