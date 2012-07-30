//
//  LevelCompletedDialog.h
//  Beezle
//
//  Created by KM Lagerstrom on 09/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IngameDialog.h"

@class Game;
@class LevelSession;

@interface LevelCompletedDialog : IngameDialog
{
	Game *_game;
}

-(id) initWithGame:(Game *)game andLevelSession:(LevelSession *)levelSession;

@end
