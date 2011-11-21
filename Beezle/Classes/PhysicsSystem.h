//
//  PhysicsSystem.h
//  Beezle
//
//  Created by Me on 08/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EntityProcessingSystem.h"
#import "artemis.h"
#import "chipmunk.h"
#import "cocos2d.h"

@interface PhysicsSystem : EntityProcessingSystem
{
    cpSpace *_space;
    cpShape *_walls[4];
}

@property (nonatomic, readonly) cpSpace *space;

@end
