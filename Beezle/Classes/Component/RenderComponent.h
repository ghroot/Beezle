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

+(RenderComponent *) componentWithContentsOfDictionary:(NSDictionary *)dict world:(World *)world;
+(RenderComponent *) componentWithRenderSprite:(RenderSprite *)renderSprite;

-(id) initWithContentsOfDictionary:(NSDictionary *)dict world:(World *)world;

-(void) addRenderSprite:(RenderSprite *)renderSprite withName:(NSString *)name;
-(RenderSprite *) getRenderSprite:(NSString *)name;
-(NSArray *) renderSprites;
-(void) setAlpha:(float)alpha;
-(void) playAnimation:(NSString *)animationName withLoops:(int)nLoops;
-(void) playAnimation:(NSString *)animationName;
-(void) playAnimation:(NSString *)animationName withCallbackTarget:(id)target andCallbackSelector:(SEL)selector;
-(void) playAnimationsLoopLast:(NSArray *)animationNames;
-(void) playAnimationsLoopAll:(NSArray *)animationNames;

@end
