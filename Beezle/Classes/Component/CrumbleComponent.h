//
//  CrumbleComponent.h
//  Beezle
//
//  Created by KM Lagerstrom on 15/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

/**
  Destroyed on collision with dozer entities.
 */
@interface CrumbleComponent : Component
{
	NSString *_crumbleSoundName;
}

@property (nonatomic, readonly) NSString *crumbleSoundName;

-(BOOL) hasCrumbleSound;

@end
