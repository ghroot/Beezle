//
//  BeePollenHandler.h
//  Beezle
//
//  Created by Marcus on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CollisionHandler.h"

@class LevelSession;

@interface BeePollenHandler : CollisionHandler
{
    LevelSession *_levelSession;
}

+(id) handlerWithLevelSession:(LevelSession *)levelSession;

-(id) initWithLevelSession:(LevelSession *)levelSession;

@end
