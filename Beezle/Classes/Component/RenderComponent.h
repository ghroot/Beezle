//
//  RenderableBehaviour.h
//  Beezle
//
//  Created by Me on 06/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Component.h"
#import "cocos2d.h"

@interface RenderComponent : Component
{
    NSString *_frameFormat;
    NSMutableDictionary *_animationsByName;
    
    CCSpriteBatchNode *_spriteSheet;
    CCSprite *_sprite;
    int _z;
}

@property (nonatomic, readonly, assign) CCSpriteBatchNode *spriteSheet;
@property (nonatomic, readonly, retain) CCSprite *sprite;
@property (nonatomic) int z;

-(id) initWithSpriteSheet:(CCSpriteBatchNode *)spriteSheet;
-(id) initWithSpriteSheet:(CCSpriteBatchNode *)spriteSheet andFrameFormat:(NSString *)frameFormat;
-(void) addAnimation:(NSString *)animationName withStartFrame:(int)startFrame andEndFrame:(int)endFrame;
-(void) addAnimation:(NSString *)animationName withFrames:(NSArray *)frames;
-(void) playAnimation:(NSString *)animationName withLoops:(int)nLoops;
-(void) playAnimation:(NSString *)animationName withCallbackTarget:(id)target andCallbackSelector:(SEL)selector;

@end
