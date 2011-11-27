//
//  PhysicsSystem.h
//  Beezle
//
//  Created by Me on 08/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EntityComponentSystem.h"
#import "artemis.h"
#import "chipmunk.h"
#import "cocos2d.h"

@interface PhysicsSystem : EntityComponentSystem
{
    cpSpace *_space;
}

@property (nonatomic, readonly) cpSpace *space;

@end
