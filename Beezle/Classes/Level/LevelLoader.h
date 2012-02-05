//
//  LevelLoader.h
//  Beezle
//
//  Created by Me on 14/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"
#import "cocos2d.h"

@class LevelLayout;

@interface LevelLoader : NSObject

+(LevelLoader *) sharedLoader;

-(LevelLayout *) loadLevelLayoutOriginal:(NSString *)levelName;
-(LevelLayout *) loadLevelLayoutEdited:(NSString *)levelName;
-(LevelLayout *) loadLevelLayoutWithHighestVersion:(NSString *)levelName;
-(void) loadLevel:(NSString *)levelName inWorld:(World *)world edit:(BOOL)edit;

@end
