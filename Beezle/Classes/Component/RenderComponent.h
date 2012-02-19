//
//  RenderableBehaviour.h
//  Beezle
//
//  Created by Me on 06/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"
#import "cocos2d.h"

@class RenderSprite;

@interface RenderComponent : Component <NSCopying>
{
	NSMutableDictionary *_renderSpritesByName;
}

+(RenderComponent *) componentWithRenderSprite:(RenderSprite *)renderSprite;

-(void) addRenderSprite:(RenderSprite *)renderSprite withName:(NSString *)name;
-(RenderSprite *) getRenderSprite:(NSString *)name;
-(NSArray *) renderSprites;
-(RenderSprite *) firstRenderSprite;
-(void) setAlpha:(float)alpha;
-(void) playAnimation:(NSString *)animationName withLoops:(int)nLoops;
-(void) playAnimation:(NSString *)animationName;
-(void) playAnimation:(NSString *)animationName withCallbackTarget:(id)target andCallbackSelector:(SEL)selector;
-(void) playAnimationsLoopLast:(NSArray *)animationNames;
-(void) playAnimationsLoopAll:(NSArray *)animationNames;

@end
