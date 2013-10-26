//
//  PlayState.h
//  Beezle
//
//  Created by Marcus on 08/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BeezleGameState.h"

@class CCMenuItemImageScale;
@class SoundButton;

@interface PlayState : BeezleGameState
{
	CCMenu *_menu;
	CCMenuItemImage *_menuItemPlay;
	CCSprite *_pollenExplodeSprite;
	SoundButton *_soundButton;
	CCMenuItemImageScale *_gameCenterMenuItem;
	float _universalScreenStartX;
}

-(void) play;

@end
