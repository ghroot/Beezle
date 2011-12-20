//
//  LevelLoader.h
//  Beezle
//
//  Created by Me on 14/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@interface LevelLoader : NSObject

+(LevelLoader *) loader;

-(void) loadLevel:(NSString *)levelName inWorld:(World *)world;

@end
