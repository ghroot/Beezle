//
//  WobbleComponent.h
//  Beezle
//
//  Created by KM Lagerstrom on 22/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@class StringList;

/**
  Plays animation on collision.
 */
@interface WobbleComponent : Component
{
    // Type
	StringList *_firstWobbleAnimationNames;
	StringList *_wobbleAnimationNames;
	StringList *_wobbleFollowupAnimationNames;
	
	// Transient
	BOOL _hasWobbled;
}

@property (nonatomic) BOOL hasWobbled;

-(NSString *) randomFirstWobbleAnimationName;
-(NSString *) randomWobbleAnimationName;
-(NSString *) randomWobbleFollowupAnimationName;

@end
