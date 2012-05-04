//
//  RenderSystem.h
//  Beezle
//
//  Created by Me on 08/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"
#import "cocos2d.h"

@class RenderSprite;
@class ZOrder;

@interface RenderSystem : EntityComponentSystem
{
    CCLayer *_layer;
    NSMutableDictionary *_spriteSheetsByName;
	NSMutableSet *_loadedAnimationsFileNames;
}

-(id) initWithLayer:(CCLayer *)layer;
-(RenderSprite *) createRenderSpriteWithSpriteSheetName:(NSString *)name animationFile:(NSString *)animationsFileName zOrder:(ZOrder *)zOrder;
-(RenderSprite *) createRenderSpriteWithSpriteSheetName:(NSString *)name zOrder:(ZOrder *)zOrder;

@end
