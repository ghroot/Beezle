//
//  LevelFailedDialog.h
//  Beezle
//
//  Created by KM Lagerstrom on 08/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Dialog.h"

@class Game;
@class LevelSession;

@interface LevelFailedDialog : Dialog
{
	Game *_game;
    LevelSession *_levelSession;
}

-(id) initWithGame:(Game *)game andLevelSession:(LevelSession *)levelSession;

-(void) restartGame;
-(void) exitGame;

@end
