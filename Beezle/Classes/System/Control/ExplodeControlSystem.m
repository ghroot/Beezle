//
//  ExplodeControlSystem.m
//  Beezle
//
//  Created by Me on 08/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ExplodeControlSystem.h"
#import "BrittleComponent.h"
#import "ExplodeComponent.h"
#import "DisposableComponent.h"
#import "EntityUtil.h"
#import "InputAction.h"
#import "InputSystem.h"
#import "NotificationTypes.h"
#import "PhysicsComponent.h"
#import "RenderSprite.h"
#import "RenderComponent.h"
#import "SoundManager.h"
#import "TransformComponent.h"

@interface ExplodeControlSystem()

-(BOOL) doesExplodedEntity:(Entity *)explodedEntity intersectBrittleEntity:(Entity *)brittleEntity;
-(void) startExplode:(Entity *)entity;
-(void) endExplode:(Entity *)entity;

@end

@implementation ExplodeControlSystem

-(id) init
{
    self = [super initWithUsedComponentClasses:[NSArray arrayWithObjects:[ExplodeComponent class], [RenderComponent class], nil]];
    return self;
}

-(void) initialise
{
	_inputSystem = (InputSystem *)[[_world systemManager] getSystem:[InputSystem class]];
}

-(void) processEntity:(Entity *)entity
{
    ExplodeComponent *explodeComponent = [ExplodeComponent getFrom:entity];
    
    while ([_inputSystem hasInputActions])
    {
        InputAction *nextInputAction = [_inputSystem popInputAction];
        if ([nextInputAction touchType] == TOUCH_BEGAN)
        {
            if ([explodeComponent explosionState] == NOT_EXPLODED)
            {
                [self startExplode:entity];
            }
        }
    }
    
    if ([explodeComponent explosionState] == WAITING_FOR_EXPLOSION)
    {
        [self endExplode:entity];
    }
}

-(BOOL) doesExplodedEntity:(Entity *)explodedEntity intersectBrittleEntity:(Entity *)brittleEntity
{
	ExplodeComponent *explodeComponent = [ExplodeComponent getFrom:explodedEntity];
	TransformComponent *explodedTransformComponent = [TransformComponent getFrom:explodedEntity];
	int left = [explodedTransformComponent position].x - [explodeComponent radius];
	int right = [explodedTransformComponent position].x + [explodeComponent radius];
	int top = [explodedTransformComponent position].y + [explodeComponent radius];
	int bottom = [explodedTransformComponent position].y - [explodeComponent radius];
	cpBB explosionBB = cpBBNew(left, bottom, right, top);
	
	PhysicsComponent *crumblePhysicsComponent = [PhysicsComponent getFrom:brittleEntity];	
	cpBB crumbleBB = [crumblePhysicsComponent boundingBox];
	
	return cpBBIntersects(explosionBB, crumbleBB);
}

-(void) startExplode:(Entity *)entity
{
    ExplodeComponent *explodeComponent = [ExplodeComponent getFrom:entity];
    [explodeComponent setExplosionState:ANIMATING_START_EXPLOSION];
    
	RenderComponent *renderComponent = [RenderComponent getFrom:entity];
	RenderSprite *defaultRenderSprite = [renderComponent defaultRenderSprite];
	[defaultRenderSprite playAnimationOnce:[explodeComponent explodeStartAnimationName] andCallBlockAtEnd:^{
		[explodeComponent setExplosionState:WAITING_FOR_EXPLOSION];
	}];
}

-(void) endExplode:(Entity *)entity
{
	ExplodeComponent *explodeComponent = [ExplodeComponent getFrom:entity];
    [explodeComponent setExplosionState:ANIMATING_END_EXPLOSION];
	
	RenderComponent *renderComponent = [RenderComponent getFrom:entity];
	RenderSprite *defaultRenderSprite = [renderComponent defaultRenderSprite];
	[defaultRenderSprite playAnimationOnce:[explodeComponent explodeEndAnimationName] andCallBlockAtEnd:^{
		[EntityUtil destroyEntity:entity instant:TRUE];
		[explodeComponent setExplosionState:EXPLODED];
	}];
	
	[EntityUtil disablePhysics:entity];
	
    [[SoundManager sharedManager] playSound:@"BombeeBoom"];
    
    for (Entity *otherEntity in [[_world entityManager] entities])
    {
        if ([otherEntity hasComponent:[BrittleComponent class]])
        {
            if ([self doesExplodedEntity:entity intersectBrittleEntity:otherEntity])
            {
                if (![EntityUtil isEntityDisposed:otherEntity])
                {
                    [EntityUtil destroyEntity:otherEntity];
                }
            }
        }
    }
}

@end
