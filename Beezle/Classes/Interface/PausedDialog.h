//
//  PausedDialog.h
//  Beezle
//
//  Created by Marcus Lagerstrom on 07/28/12.
//Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Dialog.h"

@class LevelSession;
@class Game;
@class PausedMenuState;

@interface PausedDialog : Dialog
{
	PausedMenuState *_state;
}

-(id) initWithState:(PausedMenuState *)state andLevelSession:(LevelSession *)levelSession;

-(void) resumeGame;
-(void) restartGame;
-(void) exitGame;
-(void) nextLevel;

@end
