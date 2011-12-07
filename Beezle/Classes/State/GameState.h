//
//  GameState.h
//  Beezle
//
//  Created by Me on 07/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "GameStateIds.h"

@class Game;

@interface GameState : CCScene
{
    Game *_game;
}

@property (nonatomic, assign) Game *game;

-(void) update:(ccTime)delta;

@end
