//
//  SoundComponent.h
//  Beezle
//
//  Created by Marcus on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@interface SoundComponent : Component
{
    NSString *_defaultDestroySoundName;
}

@property (nonatomic, readonly) NSString *defaultDestroySoundName;

@end
