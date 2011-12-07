//
//  MainMenuState.h
//  Beezle
//
//  Created by Me on 24/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameState.h"
#import "cocos2d.h"

@interface MainMenuState : GameState
{
    CCMenu *_menu;
}

-(void) startGameA5:(id)sender;
-(void) startGameA9:(id)sender;
-(void) startTest:(id)sender;

@end
