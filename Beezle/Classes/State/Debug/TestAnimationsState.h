//
//  TestAnimationsState.h
//  Beezle
//
//  Created by Marcus on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameState.h"
#import "artemis.h"
#import "cocos2d.h"

@class RenderSystem;

@interface TestAnimationsState : GameState
{
    CCLayer *_layer;
    World *_world;
    RenderSystem *_renderSystem;
}

@end
