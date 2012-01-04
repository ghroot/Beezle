//
//  LevelSerializer.h
//  Beezle
//
//  Created by Me on 04/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@class LevelLayout;

@interface LevelSerializer : NSObject

+(LevelSerializer *) sharedSerializer;

-(LevelLayout *) layoutFromDictionary:(NSDictionary *)dict;
-(NSDictionary *) dictionaryFromLayout:(LevelLayout *)layout;
-(LevelLayout *) layoutFromWorld:(World *)world levelName:(NSString *)levelName version:(int)version;

@end
