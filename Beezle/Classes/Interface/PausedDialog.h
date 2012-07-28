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
	LevelSession *_levelSession;

	CCLabelTTF *_levelPollenCountLabel;
	CCLabelTTF *_totalPollenCountLabel;
}

-(id) initWithState:(PausedMenuState *)state andLevelSession:(LevelSession *)levelSession;

@end
