//
//  LevelOrganizer.h
//  Beezle
//
//  Created by Me on 02/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface LevelOrganizer : NSObject
{
	NSMutableDictionary *_levelNamesByTheme;
}

+(LevelOrganizer *) sharedOrganizer;

-(void) addLevelNamesWithDictionary:(NSDictionary *)dict;
-(void) addLevelNamesWithFile:(NSString *)fileName;
-(NSArray *) themes;
-(NSArray *) levelNamesForTheme:(NSString *)theme;

@end
