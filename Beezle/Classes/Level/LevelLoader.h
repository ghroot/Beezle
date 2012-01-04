//
//  LevelLoader.h
//  Beezle
//
//  Created by Me on 14/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"
#import "cocos2d.h"

@interface LevelLoader : NSObject

+(LevelLoader *) sharedLoader;

-(void) loadLevel:(NSString *)levelName inWorld:(World *)world;
-(void) preloadAllLevelLayouts;

@end
