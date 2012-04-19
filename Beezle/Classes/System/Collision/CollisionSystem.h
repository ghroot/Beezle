//
//  CollisionSystem.h
//  Beezle
//
//  Created by Me on 15/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EntitySystem.h"
#import "artemis.h"

@class Collision;
@class LevelSession;

@interface CollisionSystem : EntitySystem
{
	LevelSession *_levelSession;
}

-(id) initWithLevelSession:(LevelSession *)levelSession;

-(BOOL) handleCollision:(Collision *)collision;

@end
