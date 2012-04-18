//
//  WaterComponent.h
//  Beezle
//
//  Created by Marcus on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@interface WaterComponent : Component
{
    NSString *_splashEntityType;
}

@property (nonatomic, copy) NSString *splashEntityType;

@end
