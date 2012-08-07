//
//  RenderComponent.m
//  Beezle
//
//  Created by Me on 06/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RenderComponent.h"
#import "RenderSprite.h"
#import "RenderSystem.h"
#import "StringCollection.h"
#import "ZOrder.h"

@interface RenderComponent()

-(void) playAnimationOnce:(NSString *)animationName andCallBlockAtEnd:(void(^)())block;
-(void) playAnimationOnce:(NSString *)animationName;

@end

@implementation RenderComponent

@synthesize renderSprites = _renderSprites;

+(RenderComponent *) componentWithRenderSprite:(RenderSprite *)renderSprite
{
	RenderComponent *renderComponent = [[[RenderComponent alloc] init] autorelease];
	[renderComponent addRenderSprite:renderSprite];
	return renderComponent;
}

-(id) init
{
	if (self = [super init])
	{
		_renderSprites = [NSMutableArray new];
	}
	return self;
}

-(id) initWithTypeComponentDict:(NSDictionary *)typeComponentDict andInstanceComponentDict:(NSDictionary *)instanceComponentDict world:(World *)world
{
	if (self = [self init])
	{
        // Type
		RenderSystem *renderSystem = (RenderSystem *)[[world systemManager] getSystem:[RenderSystem class]];
		for (NSDictionary *spriteDict in [typeComponentDict objectForKey:@"sprites"])
		{
			RenderSprite *renderSprite = nil;
            
			ZOrder *zOrder;
            if ([spriteDict objectForKey:@"z"] != nil)
            {
                zOrder = [ZOrder enumFromName:[spriteDict objectForKey:@"z"]];
            }
            else
            {
                zOrder = [ZOrder Z_DEFAULT];
            }
			if ([instanceComponentDict objectForKey:@"overrideTextureFile"] != nil)
			{
				_overrideTextureFile = [[instanceComponentDict objectForKey:@"overrideTextureFile"] copy];
				NSString *overrideTextureFile = [[CCFileUtils sharedFileUtils] fullPathFromRelativePath:_overrideTextureFile];
				renderSprite = [RenderSprite renderSpriteWithFile:overrideTextureFile zOrder:zOrder];
			}
			else if ([instanceComponentDict objectForKey:@"overrideParticleFile"] != nil)
			{
				_overrideParticleFile = [[instanceComponentDict objectForKey:@"overrideParticleFile"] copy];
				CCParticleSystem *particleSystem = [CCParticleSystemQuad particleWithFile:_overrideParticleFile];
				CCSprite *particleSprite = [CCSprite node];
				[particleSprite addChild:particleSystem];
				renderSprite = [RenderSprite renderSpriteWithSprite:particleSprite zOrder:zOrder];
			}
			else if ([spriteDict objectForKey:@"spriteSheetName"] != nil)
			{
				renderSprite = [renderSystem createRenderSpriteWithSpriteSheetName:[spriteDict objectForKey:@"spriteSheetName"] animationFile:[spriteDict objectForKey:@"animationFile"] zOrder:zOrder];
				[[renderSprite defaultIdleAnimationNames] addStringsFromDictionary:spriteDict baseName:@"defaultIdleAnimation"];
				[[renderSprite defaultHitAnimationNames] addStringsFromDictionary:spriteDict baseName:@"defaultHitAnimation"];
				[[renderSprite defaultDestroyAnimationNames] addStringsFromDictionary:spriteDict baseName:@"defaultDestroyAnimation"];
				[[renderSprite defaultStillAnimationNames] addStringsFromDictionary:spriteDict baseName:@"defaultStillAnimation"];
				
				if ([instanceComponentDict objectForKey:@"overrideIdleAnimation"] != nil)
				{
					_overrideIdleAnimationName = [[instanceComponentDict objectForKey:@"overrideIdleAnimation"] copy];
					[[renderSprite defaultIdleAnimationNames] addString:_overrideIdleAnimationName];
				}
			}
			else if ([spriteDict objectForKey:@"textureFile"] != nil)
			{
				NSString *textureFile = [[CCFileUtils sharedFileUtils] fullPathFromRelativePath:[spriteDict objectForKey:@"textureFile"]];
                renderSprite = [RenderSprite renderSpriteWithFile:textureFile zOrder:zOrder];
			}
			else if ([spriteDict objectForKey:@"particleFile"] != nil)
			{
				CCParticleSystem *particleSystem = [CCParticleSystemQuad particleWithFile:[spriteDict objectForKey:@"particleFile"]];
				CCSprite *particleSprite = [CCSprite node];
				[particleSprite addChild:particleSystem];
				renderSprite = [RenderSprite renderSpriteWithSprite:particleSprite zOrder:zOrder];
			}
			else
			{
				NSLog(@"WARNING: Render component must specify either 'spriteSheetName', 'textureFile' or 'particleFile'");
			}
            
            if ([spriteDict objectForKey:@"name"] != nil)
            {
                NSString *name = [spriteDict objectForKey:@"name"];
                [renderSprite setName:name];
            }
            
            CGPoint anchorPoint = CGPointMake(0.5f, 0.5f);
            if ([spriteDict objectForKey:@"anchorPoint"] != nil)
            {
                anchorPoint = CGPointFromString([spriteDict objectForKey:@"anchorPoint"]);
            }
            [[renderSprite sprite] setAnchorPoint:anchorPoint];
            
            if ([spriteDict objectForKey:@"scale"] != nil)
            {
                CGPoint scale = CGPointFromString([spriteDict objectForKey:@"scale"]);
                [renderSprite setScale:scale];
            }
            
			[self addRenderSprite:renderSprite];
		}
        
		[self playDefaultIdleAnimation];
	}
	return self;
}

-(void) dealloc
{
	[_renderSprites release];
	[_overrideIdleAnimationName release];
	[_overrideTextureFile release];
    
    [super dealloc];
}

-(NSDictionary *) getInstanceComponentDict
{
	NSMutableDictionary *instanceComponentDict = [NSMutableDictionary dictionary];
	if ([self defaultRenderSprite] != nil)
	{
		if (_overrideIdleAnimationName != nil)
		{
			[instanceComponentDict setObject:_overrideIdleAnimationName forKey:@"overrideIdleAnimation"];
		}
		if (_overrideTextureFile != nil)
		{
			[instanceComponentDict setObject:_overrideTextureFile forKey:@"overrideTextureFile"];
		}
	}
	return instanceComponentDict;
}

-(id) copyWithZone:(NSZone *)zone
{
	RenderComponent *copiedRenderComponent = (RenderComponent *)[super copyWithZone:zone];
	for (RenderSprite *renderSprite in _renderSprites)
	{
		RenderSprite *copiedRenderSprite = [renderSprite copy];
		[copiedRenderComponent addRenderSprite:copiedRenderSprite];
		[copiedRenderSprite release];
	}
	return copiedRenderComponent;
}

-(void) addRenderSprite:(RenderSprite *)renderSprite
{
	[_renderSprites addObject:renderSprite];
}

-(RenderSprite *) renderSpriteWithName:(NSString *)name
{
    for (RenderSprite *renderSprite in _renderSprites)
    {
        if ([[renderSprite name] isEqualToString:name])
        {
            return renderSprite;
        }
    }
    return nil;
}

-(RenderSprite *) defaultRenderSprite
{
	return [self renderSpriteWithName:@"default"];
}

-(void) setAlpha:(float)alpha
{
	for (RenderSprite *renderSprite in _renderSprites)
	{
		[[renderSprite sprite] setOpacity:(GLubyte)(alpha * 256)];
	}
}

-(void) playAnimationOnce:(NSString *)animationName andCallBlockAtEnd:(void(^)())block
{
	for (RenderSprite *renderSprite in _renderSprites)
	{
		if (renderSprite == [_renderSprites lastObject])
		{
			[renderSprite playAnimationOnce:animationName andCallBlockAtEnd:block];
		}
		else
		{
			[renderSprite playAnimationOnce:animationName];
		}
	}
}

-(void) playAnimationOnce:(NSString *)animationName
{
	for (RenderSprite *renderSprite in _renderSprites)
	{
		[renderSprite playAnimationOnce:animationName];
	}
}

-(BOOL) hasDefaultIdleAnimation
{
	for (RenderSprite *renderSprite in _renderSprites)
	{
		if (![renderSprite hasDefaultIdleAnimation])
		{
			return FALSE;
		}
	}
	return TRUE;
}

-(void) playDefaultIdleAnimation
{
	for (RenderSprite *renderSprite in _renderSprites)
	{
		[renderSprite playDefaultIdleAnimation];
	}
}

-(BOOL) hasDefaultDestroyAnimation
{
	for (RenderSprite *renderSprite in _renderSprites)
	{
		if (![renderSprite hasDefaultDestroyAnimation])
		{
			return FALSE;
		}
	}
	return TRUE;
}

-(void) playDefaultDestroyAnimationAndCallBlockAtEnd:(void(^)())block
{
	for (RenderSprite *renderSprite in _renderSprites)
	{
		if (renderSprite == [_renderSprites lastObject])
		{
			[renderSprite playDefaultDestroyAnimationAndCallBlockAtEnd:block];
		}
		else
		{
			[renderSprite playDefaultDestroyAnimation];
		}
	}
}

-(void) playDefaultDestroyAnimation
{
	for (RenderSprite *renderSprite in _renderSprites)
	{
		[renderSprite playDefaultDestroyAnimation];
	}
}

-(BOOL) hasDefaultHitAnimation
{
	for (RenderSprite *renderSprite in _renderSprites)
	{
		if (![renderSprite hasDefaultHitAnimation])
		{
			return FALSE;
		}
	}
	return TRUE;
}

-(void) playDefaultHitAnimation
{
	for (RenderSprite *renderSprite in _renderSprites)
	{
		[renderSprite playDefaultHitAnimation];
	}
}

-(BOOL) hasDefaultStillAnimation
{
	for (RenderSprite *renderSprite in _renderSprites)
	{
		if (![renderSprite hasDefaultStillAnimation])
		{
			return FALSE;
		}
	}
	return TRUE;
}

-(void) playDefaultStillAnimation
{
	for (RenderSprite *renderSprite in _renderSprites)
	{
		[renderSprite playDefaultStillAnimation];
	}
}

-(void) show
{
	for (RenderSprite *renderSprite in _renderSprites)
	{
		[renderSprite show];
	}
}

-(void) hide
{
	for (RenderSprite *renderSprite in _renderSprites)
	{
		[renderSprite hide];
	}
}

@end
