//
//  LevelCompletedDialog.h
//  Beezle
//
//  Created by KM Lagerstrom on 09/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Dialog.h"

@class Game;
@class LevelSession;

@interface LevelCompletedDialog : Dialog
{
	Game *_game;
	LevelSession *_levelSession;
}

-(id) initWithGame:(Game *)game andLevelSession:(LevelSession *)levelSession;

@end
