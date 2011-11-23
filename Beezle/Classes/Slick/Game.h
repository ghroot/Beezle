//
//  Game.h
//  Beezle
//
//  Created by Me on 23/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

@class GameContainer;

@interface Game : NSObject
{
	GameContainer *_container;
}

@property (nonatomic, assign) GameContainer *container;

-(void) update:(int)delta;
-(void) render;

@end
