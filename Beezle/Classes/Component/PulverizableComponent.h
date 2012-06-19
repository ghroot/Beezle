//
//  PulverizableComponent.h
//  Beezle
//
//  Created by Marcus Lagerstrom on 06/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@interface PulverizableComponent : Component
{
	NSDictionary *_pulverAnimationNamesByRenderSpriteName;
}

-(NSString *) pulverAnimationForRenderSpriteName:(NSString *)renderSpriteName;

@end
