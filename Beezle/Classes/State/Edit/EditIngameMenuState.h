//
//  EditIngameMenuState.h
//  Beezle
//
//  Created by Me on 18/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameState.h"
#import "cocos2d.h"

@interface EditIngameMenuState : GameState
{
    CCMenu *_menu;
	CCMenu *_flowerPollenMenu;
	CCMenuItemFont *_pollenForTwoFlowersLabel;
	CCMenuItemFont *_pollenForThreeFlowersLabel;
}

-(void) resumeGame:(id)sender;
-(void) tryGame:(id)sender;
-(void) saveLevel:(id)sender;
-(void) resetLevel:(id)sender;
-(void) gotoMainMenu:(id)sender;

@end
