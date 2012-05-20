//
//  FrozenComponent.h
//  Beezle
//
//  Created by KM Lagerstrom on 08/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@class BeeType;

@interface CapturedComponent : Component
{
	// Type
	BeeType *_defaultContainedBeeType;
	
    // Instance
	BeeType *_containedBeeType;
	
	// Transient
	BeeType *_destroyedByBeeType;
}

@property (nonatomic, assign) BeeType *defaultContainedBeeType;
@property (nonatomic, assign) BeeType *containedBeeType;
@property (nonatomic, assign) BeeType *destroyedByBeeType;

@end
