//
//  RateLevelState.h
//  Beezle
//
//  Created by KM Lagerstrom on 07/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameState.h"
#import "cocos2d.h"

@interface RateLevelState : GameState
{
	NSString *_levelName;
}

+(id) stateWithLevelName:(NSString *)levelName;

-(id) initWithLevelName:(NSString *)levelName;

@end
