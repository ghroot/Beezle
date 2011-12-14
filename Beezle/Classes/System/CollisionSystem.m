//
//  CollisionSystem.m
//  Beezle
//
//  Created by Me on 15/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CollisionSystem.h"
#import "BeeaterComponent.h"
#import "BeeComponent.h"
#import "BeeTypes.h"
#import "Collision.h"
#import "CollisionMediator.h"
#import "CollisionTypes.h"
#import "DisposableComponent.h"
#import "PhysicsBody.h"
#import "PhysicsComponent.h"
#import "PhysicsShape.h"
#import "PhysicsSystem.h"
#import "RenderComponent.h"
#import "RenderSprite.h"
#import "SimpleAudioEngine.h"
#import "SlingerComponent.h"
#import "TagManager.h"
#import "TransformComponent.h"

@interface CollisionSystem()

-(void) handleBeforeCollisionBetween:(CollisionType)type1 and:(CollisionType)type2 selector:(SEL)selector;
-(void) handleAfterCollisionBetween:(CollisionType)type1 and:(CollisionType)type2 selector:(SEL)selector;
-(CollisionMediator *) findMediatorForCollision:(Collision *)collision;

@end

@implementation CollisionSystem

-(id) init
{
    if (self = [super init])
    {
		_collisionMediators = [[NSMutableArray alloc] init];
        _collisions = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void) dealloc
{
	[_collisionMediators release];
    [_collisions release];
    
    [super dealloc];
}

-(void) pushCollision:(Collision *)collision
{
    [_collisions addObject:collision];
}

-(void) initialise
{
	[self handleAfterCollisionBetween:COLLISION_TYPE_BEE and:COLLISION_TYPE_BACKGROUND selector:@selector(handleCollisionBee:withBackground:)];
	[self handleAfterCollisionBetween:COLLISION_TYPE_BEE and:COLLISION_TYPE_BEEATER selector:@selector(handleCollisionBee:withBeeater:)];
	[self handleAfterCollisionBetween:COLLISION_TYPE_BEE and:COLLISION_TYPE_EDGE selector:@selector(handleCollisionBee:withEdge:)];
	[self handleBeforeCollisionBetween:COLLISION_TYPE_BEE and:COLLISION_TYPE_POLLEN selector:@selector(handleCollisionBee:withPollen:)];
	[self handleAfterCollisionBetween:COLLISION_TYPE_BEE and:COLLISION_TYPE_RAMP selector:@selector(handleCollisionBee:withRamp:)];
	[self handleAfterCollisionBetween:COLLISION_TYPE_BEE and:COLLISION_TYPE_MUSHROOM selector:@selector(handleCollisionBee:withMushroom:)];
    [self handleAfterCollisionBetween:COLLISION_TYPE_BEE and:COLLISION_TYPE_WOOD selector:@selector(handleCollisionBee:withWood:)];
	[self handleAfterCollisionBetween:COLLISION_TYPE_BEE and:COLLISION_TYPE_NUT selector:@selector(handleCollisionBee:withNut:)];
	[self handleAfterCollisionBetween:COLLISION_TYPE_AIM_POLLEN and:COLLISION_TYPE_EDGE selector:@selector(handleCollisionAimPollen:withEdge:)];
}

-(void) handleBeforeCollisionBetween:(CollisionType)type1 and:(CollisionType)type2 selector:(SEL)selector
{
	PhysicsSystem *physicsSystem = (PhysicsSystem *)[[_world systemManager] getSystem:[PhysicsSystem class]];
	[physicsSystem detectBeforeCollisionsBetween:type1 and:type2];
	
	CollisionMediator *mediator = [CollisionMediator mediatorWithType1:type1 type2:type2 selector:selector];
	[_collisionMediators addObject:mediator];
}

-(void) handleAfterCollisionBetween:(CollisionType)type1 and:(CollisionType)type2 selector:(SEL)selector
{
	PhysicsSystem *physicsSystem = (PhysicsSystem *)[[_world systemManager] getSystem:[PhysicsSystem class]];
	[physicsSystem detectAfterCollisionsBetween:type1 and:type2];
	
	CollisionMediator *mediator = [CollisionMediator mediatorWithType1:type1 type2:type2 selector:selector];
	[_collisionMediators addObject:mediator];
}

-(CollisionMediator *) findMediatorForCollision:(Collision *)collision
{
	for (CollisionMediator *mediator in _collisionMediators)
	{
		if ([mediator type1] == [collision type1] &&
			[mediator type2] == [collision type2])
		{
			return mediator;
		}
	}	
	return nil;
}

-(void) begin
{
    [self handleCollisions];
}

-(void) handleCollisions
{
    for (Collision *collision in _collisions)
    {
		CollisionMediator *mediator = [self findMediatorForCollision:collision];
		if (mediator != nil)
		{
			[self performSelector:[mediator selector] withObject:[collision firstEntity] withObject:[collision secondEntity]];
		}
    }
    [_collisions removeAllObjects];    
}

-(void) handleCollisionBee:(Entity *)beeEntity withRamp:(Entity *)rampEntity
{
    BeeComponent *beeComponent = (BeeComponent *)[beeEntity getComponent:[BeeComponent class]];
    BeeTypes *beeType = [beeComponent type];
    
    DisposableComponent *rampDisposableComponent = (DisposableComponent *)[rampEntity getComponent:[DisposableComponent class]];
    
    if (![rampDisposableComponent isDisposed] &&
        [beeType canDestroyRamp])
    {
		[rampDisposableComponent setIsDisposed:TRUE];
		
        // Bee is destroyed
        [beeEntity deleteEntity];
        
        // Crash animation (and delete entity at end of animation)
        RenderComponent *rampRenderComponent = (RenderComponent *)[rampEntity getComponent:[RenderComponent class]];
        [rampRenderComponent playAnimation:@"Ramp-Crash" withCallbackTarget:rampEntity andCallbackSelector:@selector(deleteEntity)];
        
        [[SimpleAudioEngine sharedEngine] playEffect:@"52144__blaukreuz__imp-02.m4a"];
    }
}

-(void) handleCollisionBee:(Entity *)beeEntity withBeeater:(Entity *)beeaterEntity
{   
    DisposableComponent *beeaterDisposableComponent = (DisposableComponent *)[beeaterEntity getComponent:[DisposableComponent class]];
    
    if (![beeaterDisposableComponent isDisposed])
    {
		[beeaterDisposableComponent setIsDisposed:TRUE];
		
		TagManager *tagManager = (TagManager *)[_world getManager:[TagManager class]];
		Entity *slingerEntity = (Entity *)[tagManager getEntity:@"SLINGER"];
		SlingerComponent *slingerComponent = (SlingerComponent *)[slingerEntity getComponent:[SlingerComponent class]];
		
		BeeaterComponent *beeaterComponent = (BeeaterComponent *)[beeaterEntity getComponent:[BeeaterComponent class]];
		
		RenderComponent *beeaterRenderComponent = (RenderComponent *)[beeaterEntity getComponent:[RenderComponent class]];
		RenderSprite *beeaterBodyRenderSprite = (RenderSprite *)[beeaterRenderComponent getRenderSprite:@"body"];
		RenderSprite *beeaterHeadRenderSprite = (RenderSprite *)[beeaterRenderComponent getRenderSprite:@"head"];
		
		TransformComponent *beeaterTransformComponent = (TransformComponent *)[beeaterEntity getComponent:[TransformComponent class]];
		
        // Bee is destroyed
        [beeEntity deleteEntity];
        
        // Bee is freed
        [slingerComponent pushBeeType:[beeaterComponent containedBeeType]];
        
        // Beater is destroyed
        [beeaterTransformComponent setScale:CGPointMake(1.0f, 1.0f)];
        [beeaterHeadRenderSprite hide];
        [beeaterBodyRenderSprite playAnimation:@"Beeater-Body-Destroy" withCallbackTarget:beeaterEntity andCallbackSelector:@selector(deleteEntity)];
    }
}

-(void) handleCollisionBee:(Entity *)beeEntity withBackground:(Entity *)backgroundEntity
{
}

-(void) handleCollisionBee:(Entity *)beeEntity withEdge:(Entity *)edgeEntity
{
	[beeEntity deleteEntity];
}

-(void) handleCollisionBee:(Entity *)beeEntity withPollen:(Entity *)pollenEntity
{
    DisposableComponent *pollenDisposableComponent = (DisposableComponent *)[pollenEntity getComponent:[DisposableComponent class]];
    
    if (![pollenDisposableComponent isDisposed])
    {
        [pollenDisposableComponent setIsDisposed:TRUE];
        
        RenderComponent *pollenRenderComponent = (RenderComponent *)[pollenEntity getComponent:[RenderComponent class]];
        [pollenRenderComponent playAnimation:@"Pollen-Pickup" withCallbackTarget:pollenEntity andCallbackSelector:@selector(deleteEntity)];
    }
}

-(void)handleCollisionBee:(Entity *)beeEntity withMushroom:(Entity *)mushroomEntity
{
    DisposableComponent *mushroomDisposableComponent = (DisposableComponent *)[mushroomEntity getComponent:[DisposableComponent class]];
    
    if (![mushroomDisposableComponent isDisposed])
    {
		[mushroomDisposableComponent setIsDisposed:TRUE];
		
        RenderComponent *mushroomRenderComponent = (RenderComponent *)[mushroomEntity getComponent:[RenderComponent class]];
        [mushroomRenderComponent playAnimationsLoopLast:[NSArray arrayWithObjects:@"Mushroom-Bounce", @"Mushroom-Idle", nil]];
    
		[[SimpleAudioEngine sharedEngine] playEffect:@"11097__a43__a43-blipp.aif"];
    }
}

-(void)handleCollisionBee:(Entity *)beeEntity withWood:(Entity *)woodEntity
{
	DisposableComponent *woodDisposableComponent = (DisposableComponent *)[woodEntity getComponent:[DisposableComponent class]];
	
	if (![woodDisposableComponent isDisposed])
	{
		[woodDisposableComponent setIsDisposed:TRUE];
		
		BeeComponent *beeComponent = (BeeComponent *)[beeEntity getComponent:[BeeComponent class]];
		BeeTypes *beeType = [beeComponent type];
		
		if ([beeType canDestroyWood])
		{
			[beeEntity deleteEntity];
			
			RenderComponent *woodRenderComponent = (RenderComponent *)[woodEntity getComponent:[RenderComponent class]];
			[woodRenderComponent playAnimation:@"Wood-Destroy" withCallbackTarget:woodEntity andCallbackSelector:@selector(deleteEntity)];
			
			[[SimpleAudioEngine sharedEngine] playEffect:@"18339__jppi-stu__sw-paper-crumple-1.aiff"];
		}
	}
}

-(void) handleCollisionBee:(Entity *)beeEntity withNut:(Entity *)nutEntity
{
	DisposableComponent *nutDisposableComponent = (DisposableComponent *)[nutEntity getComponent:[DisposableComponent class]];
	
	if (![nutDisposableComponent isDisposed])
	{
		[nutDisposableComponent setIsDisposed:TRUE];
		
		[beeEntity deleteEntity];
		
		RenderComponent *nutRenderComponent = (RenderComponent *)[nutEntity getComponent:[RenderComponent class]];
		[nutRenderComponent playAnimation:@"Nut-Collect" withCallbackTarget:nutEntity andCallbackSelector:@selector(deleteEntity)];
	}
}

-(void) handleCollisionAimPollen:(Entity *)aimPollenEntity withEdge:(Entity *)edgeEntity
{
    [aimPollenEntity deleteEntity];
}

@end
