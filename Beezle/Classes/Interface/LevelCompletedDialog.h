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

	CCSprite *_pollenSprite;
	CCNode *_pollenLabelPosition;
	CCNode *_flowerSprite1Position;
	CCNode *_flowerSprite2Position;
	CCNode *_flowerSprite3Position;

	CCSprite *_flowerSprite1;
	CCSprite *_flowerSprite2;
	CCSprite *_flowerSprite3;
}

-(id) initWithGame:(Game *)game andLevelSession:(LevelSession *)levelSession;

-(void) nextLevel;
-(void) restartGame;
-(void) exitGame;

@end
