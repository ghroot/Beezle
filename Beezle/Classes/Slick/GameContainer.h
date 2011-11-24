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
	float _updateInterval;
	BOOL _running;
	BOOL _paused;
}

@property (nonatomic) float updateInterval;
@property (nonatomic, readonly) BOOL paused;

-(id) initWithGame:(Game *)game;
-(void) setup;
-(void) start;
-(void) startInterval;
-(void) update:(int)delta;
-(void) render;
-(void) pause;
-(void) resume;
-(void) exit;

@end
