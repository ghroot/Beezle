//
//  RenderSystem.h
//  Beezle
//
//  Created by Me on 08/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EntityComponentSystem.h"
#import "artemis.h"
#import "cocos2d.h"

@class RenderSprite;

@interface RenderSystem : EntityComponentSystem
{
    CCLayer *_layer;
    NSMutableDictionary *_spriteSheetsByName;
}

-(id) initWithLayer:(CCLayer *)layer;
-(RenderSprite *) createRenderSpriteWithFile:(NSString *)fileName;
-(RenderSprite *) createRenderSpriteWithSpriteSheetName:(NSString *)name;

@end
