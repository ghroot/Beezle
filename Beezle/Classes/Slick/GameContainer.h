//
//  GameContainer.h
//  Beezle
//
//  Created by Me on 23/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

@class Game;

@interface GameContainer : NSObject
{
	Game *_game;
	NSTimer *_timer;
	BOOL *_running;
	BOOL *_paused;
}

-(id) initWithGame:(Game *)game;
-(void) start;
-(void) pause;
-(void) resume;
-(void) exit;

@end
