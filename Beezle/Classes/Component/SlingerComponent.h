//
//  BeeComponent.h
//  Beezle
//
//  Created by Me on 05/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"
#import "BeeType.h"

@class SlingerRotator;

typedef enum
{
	SLINGER_STATE_IDLE,
	SLINGER_STATE_AIMING
} SlingerState;

/**
  Slinger specific.
 */
@interface SlingerComponent : Component
{
	// Instance
	NSMutableArray *_queuedBeeTypes;

	// Transient
	SlingerState _state;
	BeeType *_loadedBeeType;
	int _aimPollenCountdown;
	float _originalRotation;
	SlingerRotator *_rotator;
	BOOL _isGogglesActive;
}

@property (nonatomic, readonly) NSArray *queuedBeeTypes;
@property (nonatomic) SlingerState state;
@property (nonatomic, readonly) BeeType *loadedBeeType;
@property (nonatomic) float originalRotation;
@property (nonatomic, retain) SlingerRotator *rotator;
@property (nonatomic) BOOL isGogglesActive;

-(void) pushBeeType:(BeeType *)beeType;
-(void) insertBeeTypeAtStart:(BeeType *)beeType;
-(BeeType *) popNextBeeType;
-(BOOL) hasMoreBees;
-(int) numberOfBeesInQueue;
-(void) clearBeeTypes;
-(void) loadNextBee;
-(void) clearLoadedBee;
-(void) revertLoadedBee;
-(BOOL) hasLoadedBee;
-(void) resetAimPollenCountdown;
-(void) decreaseAimPollenCountdown;
-(BOOL) hasAimPollenCountdownReachedZero;

@end
