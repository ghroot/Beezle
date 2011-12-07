//
//  Game.h
//  Beezle
//
//  Created by Me on 07/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h

@interface Game : NSObject

-(void) startWithState:(GameState *)gameState;
-(void) replaceState:(GameState *)gameState;
-(void) pushState:(GameState *)gameState;
-(void) popState;
-(void) popAndReplaceState:(GameState *)gameState;

@end
