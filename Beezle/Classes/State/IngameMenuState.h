//
//  IngameMenuState.h
//  Beezle
//
//  Created by Me on 06/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CocosGameState.h"
#import "cocos2d.h"
#import "slick.h"

@interface IngameMenuState : CocosGameState
{
    CCMenu *_menu;
}

-(void) resumeGame:(id)sender;
-(void) gotoMainMenu:(id)sender;

@end
