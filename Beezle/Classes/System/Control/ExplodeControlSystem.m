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
#import "PhysicsSystem.h"
#import "RenderSprite.h"
#import "RenderComponent.h"
#import "SoundManager.h"
#import "TransformComponent.h"

@interface ExplodeControlSystem()

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
	_physicsSystem = (PhysicsSystem *)[[_world systemManager] getSystem:[PhysicsSystem class]];
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
	else if ([explodeComponent explosionState] == WAITING_FOR_DESTROY)
	{
		[EntityUtil destroyEntity:entity instant:TRUE];
		[explodeComponent setExplosionState:EXPLODED];
	}
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
		[explodeComponent setExplosionState:WAITING_FOR_DESTROY];
	}];
	
	[EntityUtil disablePhysics:entity];
    
	TransformComponent *transformComponent = [TransformComponent getFrom:entity];
	ChipmunkBody *explosionBody = [ChipmunkBody staticBody];
	ChipmunkShape *explosionShape = [ChipmunkCircleShape circleWithBody:explosionBody radius:[explodeComponent radius] offset:CGPointZero];
	[explosionBody setPos:[transformComponent position]];
	NSArray *shapeQueryInfos = [[_physicsSystem space] shapeQueryAll:explosionShape];
	NSMutableArray *entitiesToDestroy = [NSMutableArray array];
	for (ChipmunkShapeQueryInfo *shapeQueryInfo in shapeQueryInfos)
	{
		Entity *otherEntity = [[shapeQueryInfo shape] data];
		if (otherEntity != nil &&
			[otherEntity hasComponent:[BrittleComponent class]] &&
			![entitiesToDestroy containsObject:otherEntity])
		{
			[entitiesToDestroy addObject:otherEntity];
		}
	}
	
    for (Entity *entityToDestroy in entitiesToDestroy)
    {
		if (![EntityUtil isEntityDisposed:entityToDestroy])
		{
			[EntityUtil destroyEntity:entityToDestroy];
		}
    }
	
	[[SoundManager sharedManager] playSound:[explodeComponent randomExplodeSoundName]];
}

@end
