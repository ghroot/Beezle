//
//  BeeComponent.h
//  Beezle
//
//  Created by Me on 05/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"
#import "BeeType.h"

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
	SlingerState _state;
	NSMutableArray *_queuedBeeTypes;
	BeeType *_loadedBeeType;
	int _aimPollenCountdown;
}

@property (nonatomic) SlingerState state;
@property (nonatomic, readonly) NSArray *queuedBeeTypes;
@property (nonatomic, readonly) BeeType *loadedBeeType;

-(void) pushBeeType:(BeeType *)beeType;
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
