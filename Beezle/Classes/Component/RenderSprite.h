//
//  RenderSprite.h
//  Beezle
//
//  Created by Me on 28/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface RenderSprite : NSObject
{
    NSMutableDictionary *_animationsByName;
    CCSpriteBatchNode *_spriteSheet;
    CCSprite *_sprite;
}

@property (nonatomic, readonly, assign) CCSpriteBatchNode *spriteSheet;
@property (nonatomic, readonly, retain) CCSprite *sprite;

-(id) initWithSpriteSheet:(CCSpriteBatchNode *)spriteSheet;
+(RenderSprite *) renderSpriteWithSpriteSheet:(CCSpriteBatchNode *)spriteSheet;
-(void) addAnimation:(NSString *)animationName withFrameName:(NSString *)frameName delay:(float)delay;
-(void) addAnimation:(NSString *)animationName withFrameName:(NSString *)frameName;
-(void) addAnimation:(NSString *)animationName withFrameNames:(NSArray *)frameNames delay:(float)delay;
-(void) addAnimation:(NSString *)animationName withFrameNames:(NSArray *)frameNames;
-(void) playAnimation:(NSString *)animationName withLoops:(int)nLoops;
-(void) playAnimation:(NSString *)animationName withCallbackTarget:(id)target andCallbackSelector:(SEL)selector;
-(void) playAnimationsLoopLast:(NSArray *)animationNames;
-(void) playAnimationsLoopAll:(NSArray *)animationNames;

@end
