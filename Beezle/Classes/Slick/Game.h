//
//  Game.h
//  Beezle
//
//  Created by Me on 23/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

@class GameContainer;
@class Touch;

@interface Game : NSObject

-(void) initialiseWithContainer:(GameContainer *)container;
-(void) updateWithContainer:(GameContainer *)container andDelta:(int)delta;
-(void) renderWithContainer:(GameContainer *)container;
-(void) touchBegan:(Touch *)touch;
-(void) touchMoved:(Touch *)touch;
-(void) touchEnded:(Touch *)touch;

@end
