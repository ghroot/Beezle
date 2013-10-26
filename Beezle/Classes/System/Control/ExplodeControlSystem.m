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
#import "EntityUtil.h"
#import "InputAction.h"
#import "InputSystem.h"
#import "PhysicsSystem.h"
#import "RenderSprite.h"
#import "RenderComponent.h"
#import "SoundManager.h"
#import "TransformComponent.h"
#import "CrumbleComponent.h"
#import "PollenComponent.h"

@interface ExplodeControlSystem()

-(BOOL) didTouchBegin;
-(void) startExplode:(Entity *)entity;
-(void) endExplode:(Entity *)entity;

@end

@implementation ExplodeControlSystem

-(id) init
{
    self = [super initWithUsedComponentClass:[ExplodeComponent class]];
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

	if ([explodeComponent explosionState] == NOT_EXPLODED &&
			[explodeComponent explodeOnTap] &&
			[self didTouchBegin])
	{
		[explodeComponent setExplosionState:EXPLOSION_TRIGGERED];
	}

	if ([explodeComponent explosionState] == EXPLOSION_TRIGGERED)
	{
		[self startExplode:entity];
	}
	else if ([explodeComponent explosionState] == WAITING_FOR_END_EXPLOSION)
	{
		[self endExplode:entity];
	}
}

-(BOOL) didTouchBegin
{
	BOOL didTouchBegin = FALSE;
	while ([_inputSystem hasInputActions])
    {
        InputAction *nextInputAction = [_inputSystem popInputAction];
        if ([nextInputAction touchType] == TOUCH_BEGAN)
        {
            didTouchBegin = TRUE;
        }
    }
	return didTouchBegin;
}

-(void) startExplode:(Entity *)entity
{
    ExplodeComponent *explodeComponent = [ExplodeComponent getFrom:entity];
    [explodeComponent setExplosionState:ANIMATING_START_EXPLOSION];

	RenderComponent *renderComponent = [RenderComponent getFrom:entity];
	RenderSprite *defaultRenderSprite = [renderComponent defaultRenderSprite];
	[defaultRenderSprite playAnimationOnce:[explodeComponent explodeStartAnimationName] andCallBlockAtEnd:^{
		[explodeComponent setExplosionState:WAITING_FOR_END_EXPLOSION];
	}];
}

-(void) endExplode:(Entity *)entity
{
	ExplodeComponent *explodeComponent = [ExplodeComponent getFrom:entity];
	[explodeComponent setExplosionState:EXPLODED];

	[EntityUtil disablePhysics:entity];
	[EntityUtil destroyEntity:entity];
    
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
			([otherEntity hasComponent:[BrittleComponent class]] ||
					([explodeComponent alsoExplodesCrumble] && [otherEntity hasComponent:[CrumbleComponent class]]) ||
					([explodeComponent alsoExplodesPollen] && [otherEntity hasComponent:[PollenComponent class]])) &&
			![entitiesToDestroy containsObject:otherEntity])
		{
			[entitiesToDestroy addObject:otherEntity];
		}
	}
	
    for (Entity *entityToDestroy in entitiesToDestroy)
    {
		if (![EntityUtil isEntityDisposed:entityToDestroy])
		{
			[EntityUtil destroyEntity:entityToDestroy instant:FALSE damage:[explodeComponent damage]];
		}
    }
	
	[[SoundManager sharedManager] playSound:[explodeComponent randomExplodeSoundName]];

	if ([explodeComponent alsoExplodesCrumble])
	{
		AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
	}
}

@end
