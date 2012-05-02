//
//  ExplodeComponent.h
//  Beezle
//
//  Created by KM Lagerstrom on 15/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Component.h"

typedef enum
{
    NOT_EXPLODED,
    ANIMATING_START_EXPLOSION,
    WAITING_FOR_EXPLOSION,
	ANIMATING_END_EXPLOSION,
    EXPLODED
} ExplosionState;

/**
  Explodes brittle entities.
 */
@interface ExplodeComponent : Component
{
	int _radius;
	NSString *_explodeStartAnimationName;
	NSString *_explodeEndAnimationName;
    ExplosionState _explosionState;
}

@property (nonatomic) int radius;
@property (nonatomic, retain) NSString *explodeStartAnimationName;
@property (nonatomic, retain) NSString *explodeEndAnimationName;
@property (nonatomic) ExplosionState explosionState;

@end
