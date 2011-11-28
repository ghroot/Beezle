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
    NSString *_frameFormat;
    NSMutableDictionary *_animationsByName;
    
    CCSpriteBatchNode *_spriteSheet;
    CCSprite *_sprite;
}

@property (nonatomic, readonly, assign) CCSpriteBatchNode *spriteSheet;
@property (nonatomic, readonly, retain) CCSprite *sprite;

-(id) initWithSpriteSheet:(CCSpriteBatchNode *)spriteSheet;
-(id) initWithSpriteSheet:(CCSpriteBatchNode *)spriteSheet andFrameFormat:(NSString *)frameFormat;
+(RenderSprite *) renderSpriteWithSpriteSheet:(CCSpriteBatchNode *)spriteSheet;
+(RenderSprite *) renderSpriteWithSpriteSheet:(CCSpriteBatchNode *)spriteSheet andFrameFormat:(NSString *)frameFormat;
-(void) addAnimation:(NSString *)animationName withFrames:(NSArray *)frames;
-(void) addAnimation:(NSString *)animationName withStartFrame:(int)startFrame andEndFrame:(int)endFrame;
-(void) playAnimation:(NSString *)animationName withLoops:(int)nLoops;
-(void) playAnimation:(NSString *)animationName withCallbackTarget:(id)target andCallbackSelector:(SEL)selector;

@end
