//
//  DebugRenderPhysicsSystem.h
//  Beezle
//
//  Created by Me on 20/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"
#import "cocos2d.h"
#import "ObjectiveChipmunk.h"

@class DebugRenderPhysicsLayer;

@interface DebugRenderPhysicsSystem : EntityComponentSystem
{
    CCScene *_scene;
    DebugRenderPhysicsLayer *_debugRenderPhysicsLayer;
}

-(id) initWithScene:(CCScene *)scene;

@end
