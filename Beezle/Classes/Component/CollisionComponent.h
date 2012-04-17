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
	BOOL _disposeEntityOnCollision;
	BOOL _disposeAnimateAndDeleteEntityOnCollision;
	BOOL _disposeAndDeleteBeeOnCollision;
	BOOL _disposeAnimateAndDeleteBeeOnCollision;
	NSString *_collisionAnimationName;
	NSString *_collisionSpawnEntityType;
}

@property (nonatomic) BOOL disposeEntityOnCollision;
@property (nonatomic) BOOL disposeAnimateAndDeleteEntityOnCollision;
@property (nonatomic) BOOL disposeAndDeleteBeeOnCollision;
@property (nonatomic) BOOL disposeAnimateAndDeleteBeeOnCollision;
@property (nonatomic, copy) NSString *collisionAnimationName;
@property (nonatomic, copy) NSString *collisionSpawnEntityType;

@end
