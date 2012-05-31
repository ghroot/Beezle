//
//  RenderSprite.h
//  Beezle
//
//  Created by Me on 28/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@class StringCollection;
@class ZOrder;

@interface RenderSprite : NSObject <NSCopying>
{
	// Type
    CCSpriteBatchNode *_spriteSheet;
    CCSprite *_sprite;
	ZOrder *_zOrder;
    NSString *_name;
    CGPoint _scale;
	CGPoint _offset;
	StringCollection *_defaultIdleAnimationNames;
	StringCollection *_defaultHitAnimationNames;
    StringCollection *_defaultDestroyAnimationNames;
	StringCollection *_defaultStillAnimationNames;
}

@property (nonatomic, readonly) CCSprite *sprite;
@property (nonatomic, readonly) CCSpriteBatchNode *spriteSheet;
@property (nonatomic, readonly) ZOrder *zOrder;
@property (nonatomic, copy) NSString *name;
@property (nonatomic) CGPoint scale;
@property (nonatomic) CGPoint offset;
@property (nonatomic, readonly) StringCollection *defaultIdleAnimationNames;
@property (nonatomic, readonly) StringCollection *defaultHitAnimationNames;
@property (nonatomic, readonly) StringCollection *defaultDestroyAnimationNames;
@property (nonatomic, readonly) StringCollection *defaultStillAnimationNames;

+(RenderSprite *) renderSpriteWithSpriteSheet:(CCSpriteBatchNode *)spriteSheet zOrder:(ZOrder *)zOrder;
+(RenderSprite *) renderSpriteWithSpriteSheet:(CCSpriteBatchNode *)spriteSheet;
+(RenderSprite *) renderSpriteWithSprite:(CCSprite *)sprite zOrder:(ZOrder *)zOrder;
+(RenderSprite *) renderSpriteWithSprite:(CCSprite *)sprite;
+(RenderSprite *) renderSpriteWithFile:(NSString *)file zOrder:(ZOrder *)zOrder;
+(RenderSprite *) renderSpriteWithFile:(NSString *)file;

-(id) initWithSpriteSheet:(CCSpriteBatchNode *)spriteSheet zOrder:(ZOrder *)zOrder;
-(id) initWithSpriteSheet:(CCSpriteBatchNode *)spriteSheet;
-(id) initWithSprite:(CCSprite *)sprite zOrder:(ZOrder *)zOrder;
-(id) initWithSprite:(CCSprite *)sprite;

-(void) addSpriteToSpriteSheet;
-(void) removeSpriteFromSpriteSheet;
-(void) markAsBackground;
-(void) playAnimationOnce:(NSString *)animationName;
-(void) playAnimationOnce:(NSString *)animationName andCallBlockAtEnd:(void(^)())block;
-(void) playAnimationLoop:(NSString *)animationName;
-(void) playAnimationsLoopAll:(NSArray *)animationNames;
-(void) playAnimationsLoopLast:(NSArray *)animationNames;
-(BOOL) hasDefaultIdleAnimation;
-(NSString *) randomDefaultIdleAnimationName;
-(void) playDefaultIdleAnimation;
-(BOOL) hasDefaultDestroyAnimation;
-(NSString *) randomDefaultDestroyAnimationName;
-(void) playDefaultDestroyAnimation;
-(void) playDefaultDestroyAnimationAndCallBlockAtEnd:(void(^)())block;
-(BOOL) hasDefaultHitAnimation;
-(NSString *) randomDefaultHitAnimationName;
-(void) playDefaultHitAnimation;
-(BOOL) hasDefaultStillAnimation;
-(NSString *) randomDefaultStillAnimationName;
-(void) playDefaultStillAnimation;
-(void) setAnimationSpeed:(float)speed;
-(void) hide;
-(void) show;

@end
