//
//  GameStateUtils.h
//  Beezle
//
//  Created by Marcus Lagerstrom on 08/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@class Game;

@interface GameStateUtils : NSObject

+(void) replaceWithGameplayState:(NSString *)levelName game:(Game *)game;

@end
