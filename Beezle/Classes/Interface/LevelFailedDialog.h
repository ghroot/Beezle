//
//  LevelFailedDialog.h
//  Beezle
//
//  Created by KM Lagerstrom on 08/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Dialog.h"

@class Game;

@interface LevelFailedDialog : Dialog
{
	Game *_game;
	NSString *_levelName;
}

-(id) initWithGame:(Game *)game andLevelName:(NSString *)levelName;

@end
