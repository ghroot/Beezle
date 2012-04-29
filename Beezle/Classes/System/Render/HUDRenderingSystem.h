//
//  HUDSystem.h
//  Beezle
//
//  Created by KM Lagerstrom on 29/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"
#import "cocos2d.h"

@interface HUDRenderingSystem : EntitySystem
{
	CCLayer *_layer;
}

-(id) initWithLayer:(CCLayer *)layer;

@end
