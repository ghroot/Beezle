//
//  BeeaterComponent.h
//  Beezle
//
//  Created by Me on 05/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"
#import "BeeType.h"

@interface BeeaterComponent : Component
{
	BeeType *_containedBeeType;
}

@property (nonatomic, assign) BeeType *containedBeeType;

-(BOOL) hasContainedBee;

@end
