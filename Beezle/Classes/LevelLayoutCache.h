//
//  LevelLayoutCache.h
//  Beezle
//
//  Created by Me on 03/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@class LevelLayout;

@interface LevelLayoutCache : NSObject
{
    NSMutableDictionary *_levelLayoutsByName;
}

+(LevelLayoutCache *) sharedLevelLayoutCache;
-(void) addLevelLayoutsWithDictionary:(NSDictionary *)dict;
-(void) addLevelLayoutsWithFile:(NSString *)fileName;
-(LevelLayout *) levelLayoutByName:(NSString *)name;

@end
