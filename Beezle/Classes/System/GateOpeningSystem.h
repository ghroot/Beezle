//
//  GateOpeningSystem.h
//  Beezle
//
//  Created by KM Lagerstrom on 23/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@class LevelSession;

@interface GateOpeningSystem : EntityComponentSystem
{
	LevelSession *_levelSession;
}

-(id) initWithLevelSession:(LevelSession *)levelSession;

@end
