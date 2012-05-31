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
}

@property (nonatomic, copy) NSString *showBeeAnimationNameFormat;
@property (nonatomic, readonly) StringCollection *showBeeBetweenAnimationNames;

@end
