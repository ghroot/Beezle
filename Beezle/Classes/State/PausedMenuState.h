//
//  IngameMenuState.h
//  Beezle
//
//  Created by Me on 06/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameState.h"
#import "cocos2d.h"

@class LevelSession;

@interface PausedMenuState : GameState
{
    NSString *_theme;
    NSString *_levelName;
}

-(id) initWithBackground:(CCNode *)backgroundNode andLevelSession:(LevelSession *)levelSession;

-(void) resumeGame;
-(void) restartGame;
-(void) exitGame;
-(void) nextLevel;

@end
