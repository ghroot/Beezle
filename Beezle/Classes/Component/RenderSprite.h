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
	StringList *_defaultIdleAnimationNames;
    StringList *_defaultDestroyAnimationNames;
}

@property (nonatomic, readonly, retain) CCSprite *sprite;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, readonly) StringList *defaultIdleAnimationNames;
@property (nonatomic, readonly) StringList *defaultDestroyAnimationNames;

+(RenderSprite *) renderSpriteWithSpriteSheet:(CCSpriteBatchNode *)spriteSheet z:(int)z;
+(RenderSprite *) renderSpriteWithSpriteSheet:(CCSpriteBatchNode *)spriteSheet;

-(id) initWithSpriteSheet:(CCSpriteBatchNode *)spriteSheet z:(int)z;
-(id) initWithSpriteSheet:(CCSpriteBatchNode *)spriteSheet;

-(void) addSpriteToSpriteSheet;
-(void) removeSpriteFromSpriteSheet;
-(void) markAsBackground;
-(void) playAnimation:(NSString *)animationName withLoops:(int)nLoops;
-(void) playAnimation:(NSString *)animationName;
-(void) playAnimation:(NSString *)animationName withCallbackTarget:(id)target andCallbackSelector:(SEL)selector;
-(void) playAnimation:(NSString *)animationName withCallbackTarget:(id)target andCallbackSelector:(SEL)selector object:(id)object;
-(void) playAnimationsLoopLast:(NSArray *)animationNames;
-(void) playAnimationsLoopAll:(NSArray *)animationNames;
-(void) playDefaultIdleAnimation;
-(NSString *) randomDefaultIdleAnimationName;
-(void) playDefaultDestroyAnimation;
-(NSString *) randomDefaultDestroyAnimationName;
-(void) hide;
-(void) show;

@end
