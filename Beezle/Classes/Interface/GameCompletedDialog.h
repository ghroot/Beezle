//
// Created by Marcus on 04/11/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "Dialog.h"

@class Game;

@interface GameCompletedDialog : Dialog
{
	Game *_game;
}

+(id) dialogWithGame:(Game *)game;

-(id) initWithGame:(Game *)game;

@end