//
//  RenderableBehaviour.m
//  Beezle
//
//  Created by Me on 06/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RenderComponent.h"

@implementation RenderComponent

@synthesize spriteSheet = _spriteSheet;
@synthesize sprite = _sprite;
@synthesize z = _z;

-(id) initWithSpriteSheet:(CCSpriteBatchNode *)spriteSheet
{
    if (self = [super init])
    {
        _frameFormat = @"";
        _animationsByName = [[NSMutableDictionary alloc] init];
        
        _spriteSheet = spriteSheet;
        _sprite = [[CCSprite spriteWithTexture:spriteSheet.texture] retain];
    }
    return self;
}

-(id) initWithSpriteSheet:(CCSpriteBatchNode *)spriteSheet andFrameFormat:(NSString *)frameFormat
{
    if (self = [super init])
    {
        _frameFormat = frameFormat;
        _animationsByName = [[NSMutableDictionary alloc] init];
        
        _spriteSheet = spriteSheet;
        NSString *spriteFrameName = [NSString stringWithFormat:_frameFormat, 1];
        _sprite = [[CCSprite spriteWithSpriteFrameName:spriteFrameName] retain];
    }
    return self;
}

-(void) dealloc
{
    [_frameFormat release];
    [_animationsByName release];
    [_sprite release];
    
    [super dealloc];
}

-(void) addAnimation:(NSString *)animationName withStartFrame:(int)startFrame andEndFrame:(int)endFrame
{
    NSMutableArray *aimationFrames = [NSMutableArray array];
    for (int i = startFrame; i <= endFrame; i++)
    {
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:_frameFormat, i]];
        [aimationFrames addObject:frame];
    }
    
    CCAnimation *animation = [CCAnimation animationWithFrames:aimationFrames delay:0.08f];
    [_animationsByName setObject:animation forKey:animationName];
}

-(void) addAnimation:(NSString *)animationName withFrames:(NSArray *)frames;
{
    NSMutableArray *aimationFrames = [NSMutableArray array];
    for (NSNumber *frameIndex in frames)
    {
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:_frameFormat, [frameIndex intValue]]];
        [aimationFrames addObject:frame];
    }
    
    CCAnimation *animation = [CCAnimation animationWithFrames:aimationFrames delay:0.08f];
    [_animationsByName setObject:animation forKey:animationName];
}

-(void) playAnimation:(NSString *)animationName withLoops:(int)nLoops
{
    CCAnimation *animation = [_animationsByName objectForKey:animationName];
    CCAction *action;
    if (nLoops == -1)
    {
        action = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation restoreOriginalFrame:NO]];
    }
    else
    {
        action = [CCRepeat actionWithAction:[CCAnimate actionWithAnimation:animation restoreOriginalFrame:NO] times:nLoops];
    }
    [_sprite runAction:action];
}

-(void) playAnimation:(NSString *)animationName withCallbackTarget:(id)target andCallbackSelector:(SEL)selector
{
    CCAnimation *animation = [_animationsByName objectForKey:animationName];
    CCRepeat *action = [CCRepeat actionWithAction:[CCAnimate actionWithAnimation:animation restoreOriginalFrame:NO] times:1];
    CCCallFunc *callbackAction = [CCCallFunc actionWithTarget:target selector:selector];
    [_sprite runAction:[CCSequence actions:action, callbackAction, nil]];
}

@end
