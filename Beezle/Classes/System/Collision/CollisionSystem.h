//
//  CollisionSystem.h
//  Beezle
//
//  Created by Me on 15/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EntitySystem.h"
#import "artemis.h"
#import "cocos2d.h"

@class Collision;
@class LevelSession;

@interface CollisionSystem : EntitySystem
{
	LevelSession *_levelSession;
	
	NSMutableArray *_collisionMediators;
}

-(id) initWithLevelSession:(LevelSession *)levelSession;

-(BOOL) handleCollision:(Collision *)collision;

@end
