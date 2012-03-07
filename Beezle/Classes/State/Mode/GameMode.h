//
//  GameMode.h
//  Beezle
//
//  Created by Me on 10/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@class GameplayState;

@interface GameMode : NSObject
{
    NSMutableArray *_systems;
    GameplayState *_gameplayState;
}

-(void) enter;
-(void) update;
-(void) leave;

-(id) initWithGameplayState:(GameplayState *)gameplayState;

-(GameMode *) nextMode;

@end
