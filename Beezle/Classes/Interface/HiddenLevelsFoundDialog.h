//
// Created by Marcus on 14/11/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "Dialog.h"

@class Game;
@class LevelSession;

@interface HiddenLevelsFoundDialog : Dialog
{
	Game *_game;
	LevelSession *_levelSession;

	CCSprite *_beeSprite1;
	CCSprite *_beeSprite2;
	CCSprite *_beeSprite3;
	CCSprite *_beeSprite4;
}

+(id) dialogWithGame:(Game *)game andLevelSession:(LevelSession *)levelSession;

-(id) initWithGame:(Game *)game andLevelSession:(LevelSession *)levelSession;

@end
