//
//  RenderSystem.h
//  Beezle
//
//  Created by Me on 08/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

#import "EntityProcessingSystem.h"

@interface RenderSystem : EntityProcessingSystem
{
    CCLayer *_layer;
}

-(id) initWithLayer:(CCLayer *)layer;

@end
