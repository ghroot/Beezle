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
-(RenderSprite *) renderSpriteWithName:(NSString *)name;
-(NSArray *) renderSprites;
-(RenderSprite *) defaultRenderSprite;
-(CGPoint) getOffsetForRenderSprite:(RenderSprite *)renderSprite;
-(void) setAlpha:(float)alpha;
-(BOOL) hasDefaultIdleAnimation;
-(void) playDefaultIdleAnimation;
-(BOOL) hasDefaultDestroyAnimation;
-(void) playDefaultDestroyAnimationAndCallBlockAtEnd:(void(^)())block;
-(void) playDefaultDestroyAnimation;

@end
