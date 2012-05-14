//
//  WaterComponent.h
//  Beezle
//
//  Created by Marcus on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

/**
  Water specific.
 */
@interface WaterComponent : Component
{
    // Type
    NSString *_splashEntityType;
}

@property (nonatomic, copy) NSString *splashEntityType;

@end
