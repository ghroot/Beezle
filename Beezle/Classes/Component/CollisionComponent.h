//
//  CollisionComponent.h
//  Beezle
//
//  Created by KM Lagerstrom on 15/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@interface CollisionComponent : Component
{
	BOOL _destroyEntityOnCollision;
	BOOL _destroyCollidingEntityOnCollision;
	NSString *_collisionAnimationName;
	NSString *_collisionSpawnEntityType;
}

@property (nonatomic) BOOL destroyEntityOnCollision;
@property (nonatomic) BOOL destroyCollidingEntityOnCollision;
@property (nonatomic, copy) NSString *collisionAnimationName;
@property (nonatomic, copy) NSString *collisionSpawnEntityType;

@end
