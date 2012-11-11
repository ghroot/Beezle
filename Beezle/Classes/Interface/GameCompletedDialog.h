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

	CCSprite *_beeSprite1;
	CCSprite *_beeSprite2;
	CCSprite *_beeSprite3;
	CCSprite *_beeSprite4;
	CCSprite *_beeSprite5;
	CCSprite *_beeSprite6;
	CCSprite *_beeSprite7;
}

+(id) dialogWithGame:(Game *)game;

-(id) initWithGame:(Game *)game;

@end
