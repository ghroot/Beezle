//
//  BeeaterComponent.h
//  Beezle
//
//  Created by Me on 05/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"
#import "BeeType.h"

@class StringCollection;

/**
  Beeater specific.
 */
@interface BeeaterComponent : Component
{
    // Type
    NSString *_showBeeAnimationNameFormat;
    StringCollection *_showBeeBetweenAnimationNames;
	StringCollection *_synchronisedBodyAnimationNames;
	StringCollection *_synchronisedHeadAnimationNames;

	// Transient
	int _synchronisedAnimationCountdown;
}

-(NSString *) headAnimationNameForBeeType:(BeeType *)beeType string:(NSString *)string;
-(NSString *) randomBetweenHeadAnimationName;
-(void) resetSynchronisedAnimationCountdown;
-(void) decreaseSynchronisedAnimationCountdown;
-(BOOL) hasSynchronisedAnimationCountdownReachedZero;
-(NSString *) randomSynchronisedBodyAnimationName;
-(NSString *) randomSynchronisedHeadAnimationName;

@end
