//
//  PlayState.h
//  Beezle
//
//  Created by Marcus on 08/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameState.h"

@interface PlayState : GameState
{
	CCMenu *_menu;
	CCMenuItemImage *_menuItemPlay;
	CCSprite *_pollenExplodeSprite;
	CCMenuItemImage *_soundOnMenuItem;
	CCMenuItemImage *_soundOffMenuItem;
}

-(void) play;
-(void) gotoSettings;
-(void) muteSound;
-(void) unMuteSound;

@end
