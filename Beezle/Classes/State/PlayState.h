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
}

-(void) play;
-(void) gotoSettings;

@end
