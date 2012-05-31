//
//  WobbleComponent.h
//  Beezle
//
//  Created by KM Lagerstrom on 22/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@class StringCollection;

/**
  Plays animation on collision.
 */
@interface WobbleComponent : Component
{
    // Type
	StringCollection *_firstWobbleAnimationNames;
	StringCollection *_wobbleAnimationNames;
	StringCollection *_wobbleFollowupAnimationNames;
	
	// Transient
	BOOL _hasWobbled;
}

@property (nonatomic) BOOL hasWobbled;

-(NSString *) randomFirstWobbleAnimationName;
-(NSString *) randomWobbleAnimationName;
-(NSString *) randomWobbleFollowupAnimationName;

@end
