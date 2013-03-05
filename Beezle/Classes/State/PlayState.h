//
//  PlayState.h
//  Beezle
//
//  Created by Marcus on 08/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BeezleGameState.h"
#import "AppGratisManager.h"

@class CCMenuItemImageScale;

@interface PlayState : BeezleGameState <AppGratisDelegate>
{
	CCMenu *_menu;
	CCMenuItemImage *_menuItemPlay;
	CCSprite *_pollenExplodeSprite;
	CCMenuItemImageScale *_gameCenterMenuItem;
	float _universalScreenStartX;
	CCNode *_appGratisNode;
}

-(void) play;
-(void) openAppGratisURL;
-(void) removeAppGratisNode;

@end
