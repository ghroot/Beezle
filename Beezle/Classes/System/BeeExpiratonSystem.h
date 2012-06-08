//
//  BeeSystem.h
//  Beezle
//
//  Created by Me on 02/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"


@interface BeeExpiratonSystem : EntityComponentSystem
{
	ComponentMapper *_beeComponentMapper;
	ComponentMapper *_physicsComponentMapper;
}

@end
