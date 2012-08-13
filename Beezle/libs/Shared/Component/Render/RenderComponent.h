//
//  RenderComponent.h
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
    // Type / Instance
	NSMutableArray *_renderSprites;
	
	// Instance
	NSString *_overrideIdleAnimationName;
	NSString *_overrideTextureFile;
	NSString *_overrideParticleFile;
}

@property (nonatomic, readonly) NSArray *renderSprites;

+(RenderComponent *) componentWithRenderSprite:(RenderSprite *)renderSprite;

-(void) addRenderSprite:(RenderSprite *)renderSprite;
-(RenderSprite *) renderSpriteWithName:(NSString *)name;
-(RenderSprite *) defaultRenderSprite;
-(RenderSprite *) firstRenderSprite;
-(RenderSprite *) lastRenderSprite;
-(void) setAlpha:(float)alpha;
-(BOOL) hasDefaultIdleAnimation;
-(void) playDefaultIdleAnimation;
-(BOOL) hasDefaultDestroyAnimation;
-(void) playDefaultDestroyAnimationAndCallBlockAtEnd:(void(^)())block;
-(void) playDefaultDestroyAnimation;
-(BOOL) hasDefaultStillAnimation;
-(void) playDefaultStillAnimation;
-(void) show;
-(void) hide;

@end
