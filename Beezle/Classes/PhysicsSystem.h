//
//  PhysicsSystem.h
//  Beezle
//
//  Created by Me on 08/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "chipmunk.h"

#import "AbstractSystem.h"

@interface PhysicsSystem : AbstractSystem
{
    cpSpace *_space;
}

@end
