//
//  TestEntitySystemState.h
//  Beezle
//
//  Created by KM Lagerstrom on 28/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameState.h"
#import "artemis.h"
#import "ObjectiveChipmunk.h"

@interface TestEntitySystemState : GameState
{
	World *_world;
	CCLabelTTF *_label;
}

@end
