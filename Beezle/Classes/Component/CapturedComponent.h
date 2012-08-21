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
	NSMutableArray *_containedBeeTypes;
	
	// Transient
	BeeType *_destroyedByBeeType;
}

@property (nonatomic, assign) BeeType *defaultContainedBeeType;
@property (nonatomic, readonly) NSArray *containedBeeTypes;
@property (nonatomic, assign) BeeType *destroyedByBeeType;

-(BeeType *) containedBeeType;
-(void) setContainedBeeType:(BeeType *)containedBeeType;

@end
