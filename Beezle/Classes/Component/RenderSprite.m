//
//  RenderSprite.m
//  Beezle
//
//  Created by Me on 28/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RenderSprite.h"
#import "ActionTags.h"

@implementation RenderSprite

@synthesize spriteSheet = _spriteSheet;
@synthesize sprite = _sprite;
@synthesize z = _z;

+(RenderSprite *) renderSpriteWithSpriteSheet:(CCSpriteBatchNode *)spriteSheet z:(int)z
{
	return [[[RenderSprite alloc] initWithSpriteSheet:spriteSheet z:z] autorelease];
}

+(RenderSprite *) renderSpriteWithSpriteSheet:(CCSpriteBatchNode *)spriteSheet
{
	return [[[RenderSprite alloc] initWithSpriteSheet:spriteSheet] autorelease];
}

// Designated initialiser
-(id) initWithSpriteSheet:(CCSpriteBatchNode *)spriteSheet z:(int)z
{
    if (self = [super init])
    {
        _spriteSheet = spriteSheet;
        _sprite = [[CCSprite alloc] initWithTexture:[spriteSheet texture]];
		_z = z;
    }
    return self;
}

-(id) initWithSpriteSheet:(CCSpriteBatchNode *)spriteSheet
{
	return [self initWithSpriteSheet:spriteSheet z:0];
}

-(void) dealloc
{
    [_sprite release];
    
    [super dealloc];
}

-(id) copyWithZone:(NSZone *)zone
{
	RenderSprite *copiedRenderSprite = [[[self class] allocWithZone:zone] initWithSpriteSheet:_spriteSheet z:_z];
	[[copiedRenderSprite sprite] setAnchorPoint:[_sprite anchorPoint]];
	[[copiedRenderSprite sprite] setDisplayFrame:[_sprite displayedFrame]];
	return copiedRenderSprite;
}

-(void) addSpriteToSpriteSheet
{
	[_spriteSheet addChild:_sprite z:_z];
}

-(void) removeSpriteFromSpriteSheet
{
	[_spriteSheet removeChild:_sprite cleanup:TRUE];
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
