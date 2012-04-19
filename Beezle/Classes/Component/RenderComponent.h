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
	NSMutableArray *_renderSprites;
    NSMutableDictionary *_renderSpriteOffsets;
}

@property (nonatomic, readonly) NSArray *renderSprites;
@property (nonatomic, retain) NSDictionary *renderSpriteOffsets;

+(RenderComponent *) componentWithRenderSprite:(RenderSprite *)renderSprite;

-(void) addRenderSprite:(RenderSprite *)renderSprite atOffset:(CGPoint)offset;
-(void) addRenderSprite:(RenderSprite *)renderSprite;
-(RenderSprite *) getRenderSprite:(NSString *)name;
-(NSArray *) renderSprites;
-(RenderSprite *) firstRenderSprite;
-(CGPoint) getOffsetForRenderSprite:(RenderSprite *)renderSprite;
-(void) setAlpha:(float)alpha;
-(void) playAnimation:(NSString *)animationName withLoops:(int)nLoops;
-(void) playAnimation:(NSString *)animationName;
-(void) playAnimation:(NSString *)animationName withCallbackTarget:(id)target andCallbackSelector:(SEL)selector;
-(void) playDefaultDestroyAnimationWithCallbackTarget:(id)target andCallbackSelector:(SEL)selector;
-(void) playAnimationsLoopLast:(NSArray *)animationNames;
-(void) playAnimationsLoopAll:(NSArray *)animationNames;
-(BOOL) hasDefaultIdleAnimation;
-(void) playDefaultIdleAnimation;
-(BOOL) hasDefaultDestroyAnimation;
-(void) playDefaultDestroyAnimation;

@end
