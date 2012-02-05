//
//  BootStrap.h
//  Beezle
//
//  Created by KM Lagerstrom on 04/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@class Game;

@interface BootStrap : NSObject
{
	Game *_game;
}

-(id) initWithGame:(Game *)game;

-(void) start;

@end
