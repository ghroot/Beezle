//
//  RenderSprite.h
//  Beezle
//
//  Created by Me on 28/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@class StringList;

@interface RenderSprite : NSObject <NSCopying>
{
    CCSpriteBatchNode *_spriteSheet;
    CCSprite *_sprite;
	int _z;
    NSString *_name;
    CGPoint _scale;
	CGPoint _offset;
	StringList *_defaultIdleAnimationNames;
	StringList *_defaultHitAnimationNames;
    StringList *_defaultDestroyAnimationNames;
}

@property (nonatomic, readonly, retain) CCSprite *sprite;
@property (nonatomic, copy) NSString *name;
@property (nonatomic) CGPoint scale;
@property (nonatomic) CGPoint offset;
@property (nonatomic, readonly) StringList *defaultIdleAnimationNames;
@property (nonatomic, readonly) StringList *defaultHitAnimationNames;
@property (nonatomic, readonly) StringList *defaultDestroyAnimationNames;

+(RenderSprite *) renderSpriteWithSpriteSheet:(CCSpriteBatchNode *)spriteSheet z:(int)z;
+(RenderSprite *) renderSpriteWithSpriteSheet:(CCSpriteBatchNode *)spriteSheet;

-(id) initWithSpriteSheet:(CCSpriteBatchNode *)spriteSheet z:(int)z;
-(id) initWithSpriteSheet:(CCSpriteBatchNode *)spriteSheet;

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
-(void) setAnimationSpeed:(float)speed;
-(void) hide;
-(void) show;

@end
