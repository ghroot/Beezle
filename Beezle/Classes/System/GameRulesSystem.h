//
//  GameRulesSystem.h
//  Beezle
//
//  Created by Me on 10/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@class LevelSession;

@interface GameRulesSystem : EntitySystem
{
    BOOL _isLevelCompleted;
    BOOL _isLevelFailed;
	LevelSession *_levelSession;
}

@property (nonatomic, readonly) BOOL isLevelCompleted;
@property (nonatomic, readonly) BOOL isLevelFailed;

-(id) initWithLevelSession:(LevelSession *)levelSession;

@end
