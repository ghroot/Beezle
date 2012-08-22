//
//  PollenComponent.h
//  Beezle
//
//  Created by KM Lagerstrom on 19/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

/**
  Entity contains pollen.
  Can be consumed by consumer entities.
 */
@interface PollenComponent : Component
{
    // Type
	int _pollenCount;
	CGPoint _pickupLabelOffset;
}

@property (nonatomic, readonly) int pollenCount;
@property (nonatomic, readonly) CGPoint pickupLabelOffset;

@end
