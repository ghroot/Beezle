//
//  RenderSprite.m
//  Beezle
//
//  Created by Me on 28/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RenderSprite.h"
#import "ActionTags.h"
#import "StringCollection.h"
#import "ZOrder.h"

@interface RenderSprite()

-(void) setAnimationSpeedOnAction:(CCAction *)action speed:(float)speed;

@end

@implementation RenderSprite

@synthesize sprite = _sprite;
@synthesize spriteSheet = _spriteSheet;
@synthesize zOrder = _zOrder;
@synthesize name = _name;
@synthesize scale = _scale;
@synthesize offset = _offset;
@synthesize defaultIdleAnimationNames = _defaultIdleAnimationNames;
@synthesize defaultDestroyAnimationNames = _defaultDestroyAnimationNames;
@synthesize defaultStillAnimationNames = _defaultStillAnimationNames;

+(RenderSprite *) renderSpriteWithSpriteSheet:(CCSpriteBatchNode *)spriteSheet zOrder:(ZOrder *)zOrder
{
	return [[[RenderSprite alloc] initWithSpriteSheet:spriteSheet zOrder:zOrder] autorelease];
}

+(RenderSprite *) renderSpriteWithSpriteSheet:(CCSpriteBatchNode *)spriteSheet
{
	return [[[RenderSprite alloc] initWithSpriteSheet:spriteSheet] autorelease];
}

+(RenderSprite *) renderSpriteWithSprite:(CCSprite *)sprite zOrder:(ZOrder *)zOrder
{
	return [[[RenderSprite alloc] initWithSprite:sprite zOrder:zOrder] autorelease];
}

+(RenderSprite *) renderSpriteWithSprite:(CCSprite *)sprite
{
	return [[[RenderSprite alloc] initWithSprite:sprite] autorelease];
}

+(RenderSprite *) renderSpriteWithFile:(NSString *)file zOrder:(ZOrder *)zOrder
{
    return [[[RenderSprite alloc] initWithSprite:[CCSprite spriteWithFile:file] zOrder:zOrder] autorelease];
}

+(RenderSprite *) renderSpriteWithFile:(NSString *)file
{
    return [self renderSpriteWithFile:file zOrder:[ZOrder Z_DEFAULT]];
}

-(id) init
{
	if (self = [super init])
	{
        _name = @"default";
        _scale = CGPointMake(1.0f, 1.0f);
		_offset = CGPointZero;
		_defaultIdleAnimationNames = [StringCollection new];
		_defaultDestroyAnimationNames = [StringCollection new];
		_defaultStillAnimationNames = [StringCollection new];
	}
	return self;
}

-(id) initWithSpriteSheet:(CCSpriteBatchNode *)spriteSheet zOrder:(ZOrder *)zOrder
{
    if (self = [self init])
    {
        _spriteSheet = spriteSheet;
        _sprite = [[CCSprite alloc] initWithTexture:[spriteSheet texture]];
		_zOrder = zOrder;
    }
    return self;
}

-(id) initWithSpriteSheet:(CCSpriteBatchNode *)spriteSheet
{
	return [self initWithSpriteSheet:spriteSheet zOrder:[ZOrder Z_DEFAULT]];
}

-(id) initWithSprite:(CCSprite *)sprite zOrder:(ZOrder *)zOrder
{
	if (self = [self init])
    {
        _sprite = [sprite retain];
        _zOrder = zOrder;
    }
    return self;
}

-(id) initWithSprite:(CCSprite *)sprite
{
	return [self initWithSprite:sprite zOrder:[ZOrder Z_DEFAULT]];
}

-(void) dealloc
{
    [_sprite release];
    [_name release];
	[_defaultIdleAnimationNames release];
	[_defaultDestroyAnimationNames release];
	[_defaultStillAnimationNames release];
    
    [super dealloc];
}

-(id) copyWithZone:(NSZone *)zone
{
	RenderSprite *copiedRenderSprite = [[[self class] allocWithZone:zone] initWithSpriteSheet:_spriteSheet zOrder:_zOrder];
	[[copiedRenderSprite sprite] setAnchorPoint:[_sprite anchorPoint]];
	[[copiedRenderSprite sprite] setDisplayFrame:[_sprite displayFrame]];
	return copiedRenderSprite;
}

-(void) addSpriteToSpriteSheet
{
	if (_spriteSheet != nil)
	{
		[_spriteSheet addChild:_sprite z:[_zOrder z]];
	}
}

-(void) removeSpriteFromSpriteSheet
{
	if (_spriteSheet != nil)
	{
		[_spriteSheet removeChild:_sprite cleanup:TRUE];
	}
}

/**
 * Applies settings that increase performance on large static textures
 */
-(void) markAsBackground
{
	[_sprite setBlendFunc:(ccBlendFunc){GL_ONE, GL_ZERO}];
	[_spriteSheet setBlendFunc:(ccBlendFunc){GL_ONE, GL_ZERO}];
}

-(void) playAnimationOnce:(NSString *)animationName
{
	[_sprite stopActionByTag:ACTION_TAG_ANIMATION];
    CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:animationName];
    CCAnimate *animationAction = [CCAnimate actionWithAnimation:animation];
    [animationAction setTag:ACTION_TAG_ANIMATION];
	[_sprite setDisplayFrameWithAnimationName:animationName index:0];
    [_sprite runAction:animationAction];
}

-(void) playAnimationOnce:(NSString *)animationName andCallBlockAtEnd:(void(^)())block
{
	[_sprite stopActionByTag:ACTION_TAG_ANIMATION];
    CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:animationName];
    CCAnimate *animationAction = [CCAnimate actionWithAnimation:animation];
	CCCallBlock *callbackAction = [CCCallBlock actionWithBlock:block];
	CCSequence *sequenceAction = [CCSequence actions:animationAction, callbackAction, nil];
    [sequenceAction setTag:ACTION_TAG_ANIMATION];
	[_sprite setDisplayFrameWithAnimationName:animationName index:0];
    [_sprite runAction:sequenceAction];
}

-(void) playAnimationLoop:(NSString *)animationName
{
	[_sprite stopActionByTag:ACTION_TAG_ANIMATION];
	CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:animationName];
	CCAnimate *animationAction = [CCAnimate actionWithAnimation:animation];
	CCRepeatForever *repeatForeverAction = [CCRepeatForever actionWithAction:animationAction];
	[repeatForeverAction setTag:ACTION_TAG_ANIMATION];
	[_sprite setDisplayFrameWithAnimationName:animationName index:0];
	[_sprite runAction:repeatForeverAction];
}

-(void) playAnimationsLoopAll:(NSArray *)animationNames
{
	[_sprite stopActionByTag:ACTION_TAG_ANIMATION];
    NSMutableArray *animationActions = [NSMutableArray array];
    for (NSString *animationName in animationNames)
    {
        CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:animationName];
		CCAnimate *animationAction = [CCAnimate actionWithAnimation:animation];
        [animationActions addObject:animationAction];
    }
	[_sprite setDisplayFrameWithAnimationName:[animationNames objectAtIndex:0] index:0];
    CCSequence *sequenceAction = [CCSequence actionWithArray:animationActions];
    CCRepeatForever *repeatForeverAction = [CCRepeatForever actionWithAction:sequenceAction];
    [repeatForeverAction setTag:ACTION_TAG_ANIMATION];
    [_sprite runAction:repeatForeverAction];
}

-(void) playAnimationsLoopLast:(NSArray *)animationNames
{
	[_sprite stopActionByTag:ACTION_TAG_ANIMATION];
    NSMutableArray *animationActions = [NSMutableArray array];
    for (NSString *animationName in animationNames)
    {
        CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:animationName];
		CCAnimate *animationAction = [CCAnimate actionWithAnimation:animation];
		if (animationName == [animationNames lastObject])
		{
			CCRepeat *repeatAction = [CCRepeat actionWithAction:animationAction times:UINT32_MAX];
			[animationActions addObject:repeatAction];
		}
		else
		{
			[animationActions addObject:animationAction];
		}
    }
	[_sprite setDisplayFrameWithAnimationName:[animationNames objectAtIndex:0] index:0];
    CCSequence *sequenceAction = [CCSequence actionWithArray:animationActions];
    [sequenceAction setTag:ACTION_TAG_ANIMATION];
    [_sprite runAction:sequenceAction];
}

-(BOOL) hasDefaultIdleAnimation
{
	return [_defaultIdleAnimationNames hasStrings];
}

-(NSString *) randomDefaultIdleAnimationName
{
	return [_defaultIdleAnimationNames randomString];
}

-(void) playDefaultIdleAnimation
{
	if ([self hasDefaultIdleAnimation])
	{
		[self playAnimationLoop:[self randomDefaultIdleAnimationName]];
	}
}

-(BOOL) hasDefaultDestroyAnimation
{
	return [_defaultDestroyAnimationNames hasStrings];
}

-(NSString *) randomDefaultDestroyAnimationName
{
	return [_defaultDestroyAnimationNames randomString];
}

-(void) playDefaultDestroyAnimation
{
	if ([self hasDefaultDestroyAnimation])
	{
		[self playAnimationOnce:[self randomDefaultDestroyAnimationName]];
	}
}

-(void) playDefaultDestroyAnimationAndCallBlockAtEnd:(void(^)())block
{
	[self playAnimationOnce:[self randomDefaultDestroyAnimationName] andCallBlockAtEnd:block];
}

-(BOOL) hasDefaultStillAnimation
{
	return [_defaultStillAnimationNames hasStrings];
}

-(NSString *) randomDefaultStillAnimationName
{
	return [_defaultStillAnimationNames randomString];
}

-(void) playDefaultStillAnimation
{
	if ([self hasDefaultStillAnimation])
	{
		[self playAnimationLoop:[self randomDefaultStillAnimationName]];
	}
}

-(void) setAnimationSpeed:(float)speed
{
	CCAction *action = [_sprite getActionByTag:ACTION_TAG_ANIMATION];
	if (action != nil)
	{
		[self setAnimationSpeedOnAction:action speed:speed];
	}
}

-(void) setAnimationSpeedOnAction:(CCAction *)action speed:(float)speed
{
	if ([action isKindOfClass:[CCAnimate class]])
	{
		CCAnimate *animationAction = (CCAnimate *)action;
		float animationDuration = [[animationAction animation] duration];
		[animationAction setDuration:(speed * animationDuration)];
	}
	else if ([action isKindOfClass:[CCRepeatForever class]])
	{
		CCRepeatForever *repeatAction = (CCRepeatForever *)action;
		[self setAnimationSpeedOnAction:[repeatAction innerAction] speed:speed];
	}
	else if ([action isKindOfClass:[CCSequence class]])
	{
		// TODO: No way to get actions from CCSequence :(
	}
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
