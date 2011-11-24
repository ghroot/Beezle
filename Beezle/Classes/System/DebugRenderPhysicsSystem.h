//
//  DebugRenderPhysicsSystem.h
//  Beezle
//
//  Created by Me on 20/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EntityComponentSystem.h"
#import "artemis.h"
#import "chipmunk.h"
#import "cocos2d.h"

@interface DebugRenderPhysicsSystem : EntityComponentSystem

-(void) drawShape:(cpShape *)shape;

@end
