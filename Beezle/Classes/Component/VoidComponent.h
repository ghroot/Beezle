//
//  VoidComponent.h
//  Beezle
//
//  Created by Marcus on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

/**
  Instantly destroys other entities on collision.
 */
@interface VoidComponent : Component
{
    // Type
	BOOL _instant;
}

@property (nonatomic) BOOL instant;

@end
