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

/**
  Has a visual representation.
 */
@interface RenderComponent : Component <NSCopying>
{
	NSMutableArray *_renderSprites;
}

@property (nonatomic, readonly) NSArray *renderSprites;

+(RenderComponent *) componentWithRenderSprite:(RenderSprite *)renderSprite;

-(void) addRenderSprite:(RenderSprite *)renderSprite;
-(RenderSprite *) renderSpriteWithName:(NSString *)name;
-(NSArray *) renderSprites;
-(RenderSprite *) defaultRenderSprite;
-(void) setAlpha:(float)alpha;
-(BOOL) hasDefaultIdleAnimation;
-(void) playDefaultIdleAnimation;
-(BOOL) hasDefaultDestroyAnimation;
-(void) playDefaultDestroyAnimationAndCallBlockAtEnd:(void(^)())block;
-(void) playDefaultDestroyAnimation;
-(BOOL) hasDefaultHitAnimation;
-(void) playDefaultHitAnimation;
-(BOOL) hasDefaultStillAnimation;
-(void) playDefaultStillAnimation;

@end
