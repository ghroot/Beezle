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
	NSString *_defaultCollisionSoundName;
    NSString *_defaultDestroySoundName;
}

@property (nonatomic, copy) NSString *defaultCollisionSoundName;
@property (nonatomic, copy) NSString *defaultDestroySoundName;

@end
