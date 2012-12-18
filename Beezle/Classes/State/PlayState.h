//
//  PlayState.h
//  Beezle
//
//  Created by Marcus on 08/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameState.h"

@class CCMenuItemImageScale;

@interface PlayState : GameState
{
	CCMenu *_menu;
	CCMenuItemImage *_menuItemPlay;
	CCSprite *_pollenExplodeSprite;
	CCMenuItemImageScale *_gameCenterMenuItem;
	float _universalScreenStartX;
}

-(void) play;

@end
