//
//  IngameDialog.h
//  Beezle
//
//  Created by Marcus on 07/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Dialog.h"

@class LevelSession;

@interface IngameDialog : Dialog
{
	LevelSession *_levelSession;

	CCMenuItemImage *_resumeOrangeMenuItem;
	CCMenuItemImage *_resumeWhiteMenuItem;
	CCMenuItemImage *_redoOrangeMenuItem;
	CCMenuItemImage *_redoWhiteMenuItem;
	CCMenuItemImage *_nextLevelOrangeMenuItem;

	CCNode *_levelPollenCountLabelPosition;
	CCNode *_totalPollenCountLabelPosition;
}

-(id) initWithInterfaceFile:(NSString *)filePath andLevelSession:(LevelSession *)levelSession;

-(void) useWhiteResumeButton;
-(void) useOrangeResumeButton;
-(void) useNoResumeButton;
-(void) resumeGame;
-(void) useOrangeRestartButton;
-(void) useWhiteRestartButton;
-(void) useNoRestartButton;
-(void) restartGame;
-(void) useOrangeNextLevelButton;
-(void) useWhiteNextLevelButton;
-(void) useNoNextLevelButton;
-(void) nextLevel;

@end
