//
//  CocosGameState.h
//  Beezle
//
//  Created by Me on 25/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameState.h"
#import "cocos2d.h"

@class ForwardLayer;

@interface CocosGameState : GameState
{
    CCScene *_scene;
    ForwardLayer *_layer;
}

@property (nonatomic, readonly) CCScene *scene;
@property (nonatomic, readonly) ForwardLayer *layer;

@end
