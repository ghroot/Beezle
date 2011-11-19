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
    CCSpriteBatchNode *_spriteSheet;
    CCSprite *_sprite;
    
    NSString *_frameFormat;
    NSMutableDictionary *_animationByName;
}

@property (nonatomic, readonly) CCSpriteBatchNode *spriteSheet;

-(id) initWithFile:(NSString *)fileName;
-(id) initWithSpriteSheetName:(NSString *)spriteSheetName andFrameFormat:(NSString *)frameFormat;
-(void) addAnimation:(NSString *)animationName withStartFrame:(int)startFrame andEndFrame:(int)endFrame;
-(void) playAnimation:(NSString *)animationName withLoops:(int)nLoops;

@end
