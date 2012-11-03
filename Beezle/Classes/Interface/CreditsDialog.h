//
// Created by Marcus on 03/11/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "Dialog.h"
#import "Game.h"

@interface CreditsDialog : Dialog
{
	Game *_game;
}

+(id) dialogWithGame:(Game *)game;

-(id) initWithGame:(Game *)game;

@end
