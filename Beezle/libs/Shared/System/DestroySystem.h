//
//  DestroySystem.h
//  Beezle
//
//  Created by Marcus Lagerstrom on 01/03/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@interface DestroySystem : EntityComponentSystem
{
	ComponentMapper *_destroyComponentMapper;
	ComponentMapper *_physicsComponentMapper;
}

@end
