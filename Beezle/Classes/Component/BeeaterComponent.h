//
//  BeeaterComponent.h
//  Beezle
//
//  Created by Me on 05/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"
#import "BeeType.h"

@class StringList;

/**
  Beeater specific.
 */
@interface BeeaterComponent : Component
{
    // Type
    NSString *_showBeeAnimationNameFormat;
    StringList *_showBeeBetweenAnimationNames;
    
    // Instance
	BeeType *_containedBeeType;
	
	// Transient
	BeeType *_destroyedByBeeType;
}

@property (nonatomic, copy) NSString *showBeeAnimationNameFormat;
@property (nonatomic, readonly) StringList *showBeeBetweenAnimationNames;
@property (nonatomic, assign) BeeType *containedBeeType;
@property (nonatomic, assign) BeeType *destroyedByBeeType;

-(BOOL) hasContainedBee;

@end
