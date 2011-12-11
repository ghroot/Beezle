//
//  BeeaterComponent.h
//  Beezle
//
//  Created by Me on 05/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"
#import "BeeTypes.h"

@interface BeeaterComponent : Component
{
	BeeTypes *_containedBeeType;
    BOOL _isKilled;
}

@property (nonatomic, assign) BeeTypes *containedBeeType;
@property (nonatomic) BOOL isKilled;

-(BOOL) hasContainedBee;

@end
