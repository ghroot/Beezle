//
//  MenuState.h
//  Beezle
//
//  Created by Me on 24/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameState.h"
#import "cocos2d.h"
#import "slick.h"

@interface MenuState : GameState
{
    StateBasedGame *_game;
    CCMenu *_menu;
    CCMenuItemImage *_startGameButton;
    CCMenuItemImage *_startTestButton;
}

-(void) startGame:(id)sender;
-(void) startTest:(id)sender;

@end
