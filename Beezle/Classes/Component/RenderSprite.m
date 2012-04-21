//
//  RenderSprite.m
//  Beezle
//
//  Created by Me on 28/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RenderSprite.h"
#import "ActionTags.h"
#import "StringList.h"

@implementation RenderSprite

@synthesize sprite = _sprite;
@synthesize name = _name;
@synthesize scale = _scale;
@synthesize offset = _offset;
@synthesize defaultIdleAnimationNames = _defaultIdleAnimationNames;
@synthesize defaultDestroyAnimationNames = _defaultDestroyAnimationNames;

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
        _name = @"default";
        _scale = CGPointMake(1.0f, 1.0f);
		_offset = CGPointZero;
		_defaultIdleAnimationNames = [StringList new];
		_defaultDestroyAnimationNames = [StringList new];
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
    [_name release];
	[_defaultIdleAnimationNames release];
	[_defaultDestroyAnimationNames release];
    
    [super dealloc];
}

-(id) copyWithZone:(NSZone *)zone
{
	RenderSprite *copiedRenderSprite = [[[self class] allocWithZone:zone] initWithSpriteSheet:_spriteSheet z:_z];
	[[copiedRenderSprite sprite] setAnchorPoint:[_sprite anchorPoint]];
	[[copiedRenderSprite sprite] setDisplayFrame:[_sprite displayFrame]];
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
    CCSequence *sequenceAction = [CCSequence actionsWithArray:animationActions];
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
    CCSequence *sequenceAction = [CCSequence actionsWithArray:animationActions];
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

-(void) hide
{
    [_sprite setVisible:FALSE];
}

-(void) show
{
    [_sprite setVisible:TRUE];
}

@end
