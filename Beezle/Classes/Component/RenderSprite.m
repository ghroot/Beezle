//
//  RenderSprite.m
//  Beezle
//
//  Created by Me on 28/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RenderSprite.h"

@implementation RenderSprite

@synthesize spriteSheet = _spriteSheet;
@synthesize sprite = _sprite;

-(id) initWithSpriteSheet:(CCSpriteBatchNode *)spriteSheet
{
    if (self = [super init])
    {
        _animationsByName = [[NSMutableDictionary alloc] init];
        _spriteSheet = spriteSheet;
        _sprite = [[CCSprite alloc] initWithTexture:[spriteSheet texture]];
    }
    return self;
}

-(void) dealloc
{
    [_animationsByName release];
    [_sprite release];
    
    [super dealloc];
}

+(RenderSprite *) renderSpriteWithSpriteSheet:(CCSpriteBatchNode *)spriteSheet
{
	return [[[RenderSprite alloc] initWithSpriteSheet:spriteSheet] autorelease];
}

-(void) addAnimation:(NSString *)animationName withFrameName:(NSString *)frameName
{
    CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
    CCAnimation *animation = [CCAnimation animationWithFrames:[NSArray arrayWithObject:frame] delay:0.08f];
    [_animationsByName setObject:animation forKey:animationName];
}

-(void) addAnimation:(NSString *)animationName withFrameNames:(NSArray *)frameNames
{
    NSMutableArray *frames = [NSMutableArray array];
    for (NSString *frameName in frameNames)
    {
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
        [frames addObject:frame];
    }
    CCAnimation *animation = [CCAnimation animationWithFrames:frames delay:0.08f];
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
