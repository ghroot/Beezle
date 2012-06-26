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
@class CollisionHandler;

@interface CollisionSystem : EntitySystem
{
	LevelSession *_levelSession;
	NSMutableArray *_handlers;
}

-(id) initWithLevelSession:(LevelSession *)levelSession;

-(void) registerCollisionHandler:(CollisionHandler *)handler;
-(BOOL) handleCollision:(Collision *)collision;

@end
