//
//  MenuState.h
//  Beezle
//
//  Created by Me on 24/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CocosGameState.h"
#import "cocos2d.h"
#import "slick.h"

@interface MainMenuState : CocosGameState
{
    CCMenu *_menu;
}

-(void) startGame:(id)sender;
-(void) startTest:(id)sender;

@end
