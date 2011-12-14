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
    CCSpriteBatchNode *_spriteSheet;
    CCSprite *_sprite;
	int _z;
}

@property (nonatomic, readonly, assign) CCSpriteBatchNode *spriteSheet;
@property (nonatomic, readonly, retain) CCSprite *sprite;
@property (nonatomic, readonly) int z;

-(id) initWithSpriteSheet:(CCSpriteBatchNode *)spriteSheet z:(int)z;
-(id) initWithSpriteSheet:(CCSpriteBatchNode *)spriteSheet;
+(RenderSprite *) renderSpriteWithSpriteSheet:(CCSpriteBatchNode *)spriteSheet z:(int)z;
+(RenderSprite *) renderSpriteWithSpriteSheet:(CCSpriteBatchNode *)spriteSheet;
-(void) addSpriteToSpriteSheet;
-(void) removeSpriteFromSpriteSheet;
-(void) markAsBackground;
-(void) playAnimation:(NSString *)animationName withLoops:(int)nLoops;
-(void) playAnimation:(NSString *)animationName;
-(void) playAnimation:(NSString *)animationName withCallbackTarget:(id)target andCallbackSelector:(SEL)selector;
-(void) playAnimationsLoopLast:(NSArray *)animationNames;
-(void) playAnimationsLoopAll:(NSArray *)animationNames;
-(void) setFrame:(NSString *)frameName;
-(void) hide;
-(void) show;

@end
