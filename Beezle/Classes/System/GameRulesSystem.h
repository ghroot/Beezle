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
    BOOL _isBeeFlying;
	LevelSession *_levelSession;
}

@property (nonatomic, readonly) BOOL isLevelCompleted;
@property (nonatomic, readonly) BOOL isLevelFailed;
@property (nonatomic, readonly) BOOL isBeeFlying;

-(id) initWithLevelSession:(LevelSession *)levelSession;

@end
