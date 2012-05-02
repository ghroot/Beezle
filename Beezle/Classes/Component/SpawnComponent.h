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
	NSString *_entityType;
	CGPoint _offset;
	BOOL _autoDestroy;
	float _interval;
	float _intervalRandomDeviation;
	float _countdown;
}

@property (nonatomic, readonly) NSString *entityType;
@property (nonatomic, readonly) CGPoint offset;
@property (nonatomic, readonly) BOOL autoDestroy;
@property (nonatomic, readonly) float interval;
@property (nonatomic, readonly) float intervalRandomDeviation;
@property (nonatomic) float countdown;

-(void) resetCountdown;
-(void) decreaseAutoDestroyCountdown:(float)time;
-(BOOL) didAutoDestroyCountdownReachZero;

@end
