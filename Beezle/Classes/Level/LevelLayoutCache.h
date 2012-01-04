//
//  LevelLayoutCache.h
//  Beezle
//
//  Created by Me on 03/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"
#import "cocos2d.h"

@class LevelLayout;

@interface LevelLayoutCache : NSObject
{
    NSMutableDictionary *_levelLayoutsByName;
}

+(LevelLayoutCache *) sharedLevelLayoutCache;
-(void) addLevelLayout:(LevelLayout *)levelLayout;
-(void) addLevelLayoutWithDictionary:(NSDictionary *)dict;
-(void) addLevelLayoutWithWorld:(World *)world levelName:(NSString *)levelName version:(int)version;
-(NSArray *) allLevelLayoutsByName:(NSString *)name;
-(LevelLayout *) latestLevelLayoutByName:(NSString *)name;
-(void) purgeAllCachedLevelLayouts;
-(void) purgeCachedLevelLayout:(NSString *)levelName;

@end
