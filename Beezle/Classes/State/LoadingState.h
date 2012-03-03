//
//  LoadingState.h
//  Beezle
//
//  Created by KM Lagerstrom on 03/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameState.h"

@interface LoadingState : GameState
{
	GameState *_gameStateToLoad;
	BOOL _initialiseAndReplaceScene;
}

+(id) stateWithGameState:(GameState *)gameState;

-(id) initWithGameState:(GameState *)gameState;

@end
