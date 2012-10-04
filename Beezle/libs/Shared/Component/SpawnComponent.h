//
//  SpawnComponent.h
//  Beezle
//
//  Created by KM Lagerstrom on 10/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"
#import "cocos2d.h"

/**
  Spawns entities with a regular interval.
 */
@interface SpawnComponent : Component
{
    // Type
	NSString *_entityType;
	CGPoint _offset;
	BOOL _autoDestroy;
	float _interval;
	float _intervalRandomDeviation;
	BOOL _spawnWhenDestroyed;
	BOOL _keepRotation;
    
    // Transient
	float _countdown;
}

@property (nonatomic, readonly) NSString *entityType;
@property (nonatomic, readonly) CGPoint offset;
@property (nonatomic, readonly) BOOL autoDestroy;
@property (nonatomic, readonly) float interval;
@property (nonatomic, readonly) float intervalRandomDeviation;
@property (nonatomic, readonly) BOOL spawnWhenDestroyed;
@property (nonatomic, readonly) BOOL keepRotation;
@property (nonatomic) float countdown;

-(BOOL) hasCountdown;
-(void) resetCountdown;
-(void) decreaseCountdown:(float)time;
-(BOOL) didCountdownReachZero;

@end
