//
//  RenderSprite.m
//  Beezle
//
//  Created by Me on 28/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RenderSprite.h"

typedef enum
{
    ACTION_TAG_ANIMATION,
} ActionTag;

@implementation RenderSprite

@synthesize spriteSheet = _spriteSheet;
@synthesize sprite = _sprite;

-(id) initWithSpriteSheet:(CCSpriteBatchNode *)spriteSheet
{
    if (self = [super init])
    {
        _spriteSheet = spriteSheet;
        _sprite = [[CCSprite alloc] initWithTexture:[spriteSheet texture]];
    }
    return self;
}

-(void) dealloc
{
    [_sprite release];
    
    [super dealloc];
}

+(RenderSprite *) renderSpriteWithSpriteSheet:(CCSpriteBatchNode *)spriteSheet
{
	return [[[RenderSprite alloc] initWithSpriteSheet:spriteSheet] autorelease];
}

/**
* Applies settings that increase performance on large static textures
*/
-(void) markAsBackground
{
	[_sprite setBlendFunc:(ccBlendFunc){GL_ONE, GL_ZERO}];
	[_spriteSheet setBlendFunc:(ccBlendFunc){GL_ONE, GL_ZERO}];
	
//	ccTexParams params = {GL_NEAREST, GL_REPEAT, GL_REPEAT};
//	[_spriteSheet.texture setTexParameters: &params];
}

-(void) playAnimation:(NSString *)animationName withLoops:(int)nLoops
{
    [_sprite stopActionByTag:ACTION_TAG_ANIMATION];
    
    CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:animationName];
    CCAction *action;
    if (nLoops == -1)
    {
        action = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation restoreOriginalFrame:NO]];
    }
    else
    {
        action = [CCRepeat actionWithAction:[CCAnimate actionWithAnimation:animation restoreOriginalFrame:NO] times:nLoops];
    }
    [action setTag:ACTION_TAG_ANIMATION];
    
    // This instantly sets the frame instead of waiting for the first update
    [_sprite setDisplayFrame:[[animation frames] objectAtIndex:0]];
    
    [_sprite runAction:action];
}

-(void) playAnimation:(NSString *)animationName
{
	[self playAnimation:animationName withLoops:-1];
}

-(void) playAnimation:(NSString *)animationName withCallbackTarget:(id)target andCallbackSelector:(SEL)selector
{
    [_sprite stopActionByTag:ACTION_TAG_ANIMATION];
    
    CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:animationName];
    CCRepeat *action = [CCRepeat actionWithAction:[CCAnimate actionWithAnimation:animation restoreOriginalFrame:NO] times:1];
    CCCallFunc *callbackAction = [CCCallFunc actionWithTarget:target selector:selector];
    
    // This instantly sets the frame instead of waiting for the first update
    [_sprite setDisplayFrame:[[animation frames] objectAtIndex:0]];
    
    CCSequence *sequence = [CCSequence actions:action, callbackAction, nil];
    [sequence setTag:ACTION_TAG_ANIMATION];
    [_sprite runAction:sequence];
}

-(void) playAnimationsLoopLast:(NSArray *)animationNames
{
    [_sprite stopActionByTag:ACTION_TAG_ANIMATION];
    
    NSMutableArray *actions = [NSMutableArray array];
    for (NSString *animationName in animationNames)
    {
        CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:animationName];
        int nLoops = animationName == [animationNames lastObject] ? -1 : 1;
        CCRepeat *action = [CCRepeat actionWithAction:[CCAnimate actionWithAnimation:animation restoreOriginalFrame:NO] times:nLoops];
        [actions addObject:action];
    }
    
    // This instantly sets the frame instead of waiting for the first update
	CCAnimation *firstAnimation = [[CCAnimationCache sharedAnimationCache] animationByName:[animationNames objectAtIndex:0]];
    [_sprite setDisplayFrame:[[firstAnimation frames] objectAtIndex:0]];
    
    CCSequence *sequence = [CCSequence actionsWithArray:actions];
    [sequence setTag:ACTION_TAG_ANIMATION];
    [_sprite runAction:sequence];
}

-(void) playAnimationsLoopAll:(NSArray *)animationNames
{
    [_sprite stopActionByTag:ACTION_TAG_ANIMATION];
    
    NSMutableArray *actions = [NSMutableArray array];
    for (NSString *animationName in animationNames)
    {
        CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:animationName];
        CCRepeat *action = [CCRepeat actionWithAction:[CCAnimate actionWithAnimation:animation restoreOriginalFrame:NO] times:1];
        [actions addObject:action];
    }
	
	// This instantly sets the frame instead of waiting for the first update
    CCAnimation *firstAnimation = [[CCAnimationCache sharedAnimationCache] animationByName:[animationNames objectAtIndex:0]];
    [_sprite setDisplayFrame:[[firstAnimation frames] objectAtIndex:0]];
    
    CCRepeatForever *repeat = [CCRepeatForever actionWithAction:[CCSequence actionsWithArray:actions]];
    [repeat setTag:ACTION_TAG_ANIMATION];
    [_sprite runAction:repeat];
}

-(void) setFrame:(NSString *)frameName
{
	CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
	[_sprite setDisplayFrame:frame];
}

-(void) hide
{
    [_sprite setVisible:FALSE];
}

-(void) show
{
    [_sprite setVisible:TRUE];
}

@end
