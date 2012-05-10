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
	BeeType *_containedBeeType;
}

@property (nonatomic, assign) BeeType *containedBeeType;

@end
