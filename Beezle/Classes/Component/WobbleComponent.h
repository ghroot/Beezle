//
//  WobbleComponent.h
//  Beezle
//
//  Created by KM Lagerstrom on 22/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@class StringList;

@interface WobbleComponent : Component
{
	StringList *_wobbleAnimationNames;
}

-(NSString *) randomWobbleAnimationName;

@end
