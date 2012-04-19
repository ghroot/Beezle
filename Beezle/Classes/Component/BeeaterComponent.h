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

@interface BeeaterComponent : Component
{
	BeeType *_containedBeeType;
    NSString *_showBeeAnimationNameFormat;
    StringList *_showBeeBetweenAnimationNames;
}

@property (nonatomic, assign) BeeType *containedBeeType;
@property (nonatomic, copy) NSString *showBeeAnimationNameFormat;
@property (nonatomic, readonly) StringList *showBeeBetweenAnimationNames;

-(BOOL) hasContainedBee;

@end
