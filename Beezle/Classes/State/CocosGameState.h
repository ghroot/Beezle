//
//  CocosGameState.h
//  Beezle
//
//  Created by Me on 25/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameState.h"
#import "cocos2d.h"

@interface CocosGameState : GameState
{
    CCScene *_scene;
    CCLayer *_layer;
}

@end
