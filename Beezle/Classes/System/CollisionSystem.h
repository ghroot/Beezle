//
//  CollisionSystem.h
//  Beezle
//
//  Created by Me on 15/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EntityComponentSystem.h"
#import "artemis.h"

@class Collision;

@interface CollisionSystem : EntityComponentSystem
{
    NSMutableArray *_collisions;
}

-(void) pushCollision:(Collision *)collision;
-(void) handleCollisions;
-(void) handleCollisionBee:(Entity *)beeEntity withRamp:(Entity *)rampEntity;
-(void) handleCollisionBee:(Entity *)beeEntity withBeeater:(Entity *)beeaterEntity;
-(void) handleCollisionBee:(Entity *)beeEntity withBackground:(Entity *)backgroundEntity;
-(void) handleCollisionBee:(Entity *)beeEntity withEdge:(Entity *)edgeEntity;
-(void) handleCollisionBee:(Entity *)beeEntity withPollen:(Entity *)pollenEntity;
-(void) handleCollisionBee:(Entity *)beeEntity withMushroom:(Entity *)mushroomEntity;

@end
