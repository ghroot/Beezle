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

-(id) initWithFile:(NSString *)fileName;
{
    if (self = [super init])
    {
        _spriteSheet = [[CCSpriteBatchNode batchNodeWithFile:fileName capacity:100] retain];
        _sprite = [[CCSprite spriteWithTexture:_spriteSheet.texture] retain];
        [_spriteSheet addChild:_sprite];
    }
    return self;
}

-(id) initWithSpriteSheetName:(NSString *)spriteSheetName andFrameFormat:(NSString *)frameFormat
{
    if (self = [super init])
    {
        _frameFormat = frameFormat;
        _animationByName = [[NSMutableDictionary alloc] init];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[NSString stringWithFormat:@"%@.plist", spriteSheetName]];
        _spriteSheet = [[CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"%@.png", spriteSheetName]] retain];
        NSString *spriteFrameName = [NSString stringWithFormat:_frameFormat, 1];
        _sprite = [[CCSprite spriteWithSpriteFrameName:spriteFrameName] retain];
        [_spriteSheet addChild:_sprite];
    }
    return self;
}

-(void) dealloc
{
    [_spriteSheet release];
    [_sprite release];
    
    if (_frameFormat != nil)
    {
        [_frameFormat release];
    }
    if (_animationByName != nil)
    {
        [_animationByName release];
    }
    
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
    [_animationByName setObject:animation forKey:animationName];
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
    [_animationByName setObject:animation forKey:animationName];
}

-(void) playAnimation:(NSString *)animationName withLoops:(int)nLoops
{
    CCAnimation *animation = [_animationByName objectForKey:animationName];
    CCAction *action = [CCRepeat actionWithAction:[CCAnimate actionWithAnimation:animation restoreOriginalFrame:NO] times:nLoops];
    [_sprite runAction:action];
}

-(void) playAnimation:(NSString *)animationName withCallbackTarget:(id)target andCallbackSelector:(SEL)selector
{
    CCAnimation *animation = [_animationByName objectForKey:animationName];
    CCRepeat *action = [CCRepeat actionWithAction:[CCAnimate actionWithAnimation:animation restoreOriginalFrame:NO] times:1];
    CCCallFunc *callbackAction = [CCCallFunc actionWithTarget:target selector:selector];
    [_sprite runAction:[CCSequence actions:action, callbackAction, nil]];
}

@end
