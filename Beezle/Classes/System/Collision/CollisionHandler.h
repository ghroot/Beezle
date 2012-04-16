//
//  CollisionHandler.h
//  Beezle
//
//  Created by Marcus on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"
#import "cocos2d.h"

@class Collision;
@class CollisionType;
@class LevelSession;

@interface CollisionHandler : NSObject
{
	World *_world;
    LevelSession *_levelSession;
    CollisionType *_firstCollisionType;
    NSMutableArray *_secondCollisionTypes;
}

@property (nonatomic, readonly) CollisionType *firstCollisionType;
@property (nonatomic, readonly) NSArray *secondCollisionTypes;

+(id) handlerWithWorld:(World *)world andLevelSession:(LevelSession *)levelSession;

-(id) initWithWorld:(World *)world andLevelSession:(LevelSession *)levelSession;

-(BOOL) handleCollision:(Collision *)collision;

@end
