//
//  FadeSystem
//  Beezle
//
//  Created by marcus on 06/06/2012.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@interface FadeSystem : EntityComponentSystem
{
	ComponentMapper *_fadeComponentMapper;
	ComponentMapper *_renderComponentMapper;
	ComponentMapper *_disposableComponentMapper;
}

@end