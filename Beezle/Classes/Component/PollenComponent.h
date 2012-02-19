//
//  PollenComponent.h
//  Beezle
//
//  Created by KM Lagerstrom on 19/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@interface PollenComponent : Component
{
	int _pollenCount;
}

@property (nonatomic, readonly) int pollenCount;

@end
