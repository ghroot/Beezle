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

-(void) addAnimation:(NSString *)animationName withFrameName:(NSString *)frameName delay:(float)delay
{
    CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
    CCAnimation *animation = [CCAnimation animationWithFrames:[NSArray arrayWithObject:frame] delay:delay];
    [_animationsByName setObject:animation forKey:animationName];
}

-(void) addAnimation:(NSString *)animationName withFrameName:(NSString *)frameName
{
    [self addAnimation:animationName withFrameName:frameName delay:0.08f];
}

-(void) addAnimation:(NSString *)animationName withFrameNames:(NSArray *)frameNames delay:(float)delay
{
    NSMutableArray *frames = [NSMutableArray array];
    for (NSString *frameName in frameNames)
    {
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
        [frames addObject:frame];
    }
    CCAnimation *animation = [CCAnimation animationWithFrames:frames delay:delay];
    [_animationsByName setObject:animation forKey:animationName];
}

-(void) addAnimation:(NSString *)animationName withFrameNames:(NSArray *)frameNames
{
    [self addAnimation:animationName withFrameNames:frameNames delay:0.08f];
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
    
    // This instantly sets the frame instead of waiting for the first update
    [_sprite setDisplayFrame:[[animation frames] objectAtIndex:0]];
    
    [_sprite runAction:action];
}

-(void) playAnimation:(NSString *)animationName withCallbackTarget:(id)target andCallbackSelector:(SEL)selector
{
    CCAnimation *animation = [_animationsByName objectForKey:animationName];
    CCRepeat *action = [CCRepeat actionWithAction:[CCAnimate actionWithAnimation:animation restoreOriginalFrame:NO] times:1];
    CCCallFunc *callbackAction = [CCCallFunc actionWithTarget:target selector:selector];
    
    // This instantly sets the frame instead of waiting for the first update
    [_sprite setDisplayFrame:[[animation frames] objectAtIndex:0]];
    
    [_sprite runAction:[CCSequence actions:action, callbackAction, nil]];
}

-(void) playAnimationsLoopLast:(NSArray *)animationNames
{
    NSMutableArray *actions = [NSMutableArray array];
    for (NSString *animationName in animationNames)
    {
        CCAnimation *animation = [_animationsByName objectForKey:animationName];
        int nLoops = animationName == [animationNames lastObject] ? -1 : 1;
        CCRepeat *action = [CCRepeat actionWithAction:[CCAnimate actionWithAnimation:animation restoreOriginalFrame:NO] times:nLoops];
        [actions addObject:action];
    }
    
    // This instantly sets the frame instead of waiting for the first update
    CCAnimation *firstAnimation = [_animationsByName objectForKey:[animationNames objectAtIndex:0]];
    [_sprite setDisplayFrame:[[firstAnimation frames] objectAtIndex:0]];
    
    [_sprite runAction:[CCSequence actionsWithArray:actions]];
}

-(void) playAnimationsLoopAll:(NSArray *)animationNames
{
    NSMutableArray *actions = [NSMutableArray array];
    for (NSString *animationName in animationNames)
    {
        CCAnimation *animation = [_animationsByName objectForKey:animationName];
        CCRepeat *action = [CCRepeat actionWithAction:[CCAnimate actionWithAnimation:animation restoreOriginalFrame:NO] times:1];
        [actions addObject:action];
    }
	
	// This instantly sets the frame instead of waiting for the first update
    CCAnimation *firstAnimation = [_animationsByName objectForKey:[animationNames objectAtIndex:0]];
    [_sprite setDisplayFrame:[[firstAnimation frames] objectAtIndex:0]];
	
	[_sprite runAction:[CCRepeatForever actionWithAction:[CCSequence actionsWithArray:actions]]];
}

@end
