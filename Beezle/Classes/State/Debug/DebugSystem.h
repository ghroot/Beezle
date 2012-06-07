//
//  DebugSystem.h
//  Beezle
//
//  Created by KM Lagerstrom on 28/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@interface DebugSystem : EntityComponentSystem
{
	BOOL _slow;
	ComponentMapper *_transformComponentMapper;
}

@property (nonatomic) BOOL slow;

@end
