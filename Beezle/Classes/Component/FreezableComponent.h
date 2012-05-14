//
//  FreezableComponent.h
//  Beezle
//
//  Created by KM Lagerstrom on 10/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@interface FreezableComponent : Component
{
    // Transient
	BOOL _isFrozen;
}

@property (nonatomic) BOOL isFrozen;

@end
