//
//  GameRulesSystem.h
//  Beezle
//
//  Created by Me on 10/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@interface GameRulesSystem : EntitySystem
{
    BOOL _isLevelCompleted;
    BOOL _isLevelFailed;
    BOOL _isBeeFlying;
    NSMutableArray *_beeQueue;
}

@property (nonatomic, readonly) BOOL isLevelCompleted;
@property (nonatomic, readonly) BOOL isLevelFailed;
@property (nonatomic, readonly) BOOL isBeeFlying;
@property (nonatomic, readonly) NSArray *beeQueue;

@end
