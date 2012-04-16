//
//  BeeHandler.h
//  Beezle
//
//  Created by Marcus on 4/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CollisionHandler.h"
#import "artemis.h"

@class LevelSession;

@interface BeeHandler : CollisionHandler
{
	World *_world;
    LevelSession *_levelSession;
}

+(id) handlerWithWorld:(World *)world andLevelSession:(LevelSession *)levelSession;

-(id) initWithWorld:(World *)world andLevelSession:(LevelSession *)levelSession;

@end
