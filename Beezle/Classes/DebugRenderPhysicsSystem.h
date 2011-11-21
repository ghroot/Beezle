//
//  DebugRenderPhysicsSystem.h
//  Beezle
//
//  Created by Me on 20/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EntityProcessingSystem.h"
#import "artemis.h"
#import "chipmunk.h"
#import "cocos2d.h"

@interface DebugRenderPhysicsSystem : EntityProcessingSystem

-(void) drawShape:(cpShape *)shape;

@end
