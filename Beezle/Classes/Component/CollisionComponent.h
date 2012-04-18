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
	NSString *_collisionAnimationName;
}

@property (nonatomic) BOOL destroyEntityOnCollision;
@property (nonatomic, copy) NSString *collisionAnimationName;

@end
