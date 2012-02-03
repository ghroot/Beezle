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
#import "BeeType.h"
#import "Collision.h"
#import "CollisionMediator.h"
#import "CollisionType.h"
#import "DisposableComponent.h"
#import "EntityUtil.h"
#import "NotificationTypes.h"
#import "PhysicsComponent.h"
#import "PhysicsSystem.h"
#import "RenderComponent.h"
#import "RenderSprite.h"
#import "SlingerComponent.h"
#import "SoundManager.h"
#import "TagManager.h"
#import "TransformComponent.h"

@interface CollisionSystem()

-(void) handleBeforeCollisionBetween:(CollisionType *)type1 and:(CollisionType *)type2 selector:(SEL)selector;
-(void) handleAfterCollisionBetween:(CollisionType *)type1 and:(CollisionType *)type2 selector:(SEL)selector;
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
	[self handleAfterCollisionBetween:[CollisionType BEE] and:[CollisionType BACKGROUND] selector:@selector(handleCollisionBee:withBackground:)];
	[self handleAfterCollisionBetween:[CollisionType BEE] and:[CollisionType BEEATER] selector:@selector(handleCollisionBee:withBeeater:)];
	[self handleAfterCollisionBetween:[CollisionType BEE] and:[CollisionType EDGE] selector:@selector(handleCollisionBee:withEdge:)];
	[self handleBeforeCollisionBetween:[CollisionType BEE] and:[CollisionType POLLEN] selector:@selector(handleCollisionBee:withPollen:)];
	[self handleAfterCollisionBetween:[CollisionType BEE] and:[CollisionType RAMP] selector:@selector(handleCollisionBee:withRamp:)];
	[self handleAfterCollisionBetween:[CollisionType BEE] and:[CollisionType MUSHROOM] selector:@selector(handleCollisionBee:withMushroom:)];
    [self handleAfterCollisionBetween:[CollisionType BEE] and:[CollisionType WOOD] selector:@selector(handleCollisionBee:withWood:)];
	[self handleAfterCollisionBetween:[CollisionType BEE] and:[CollisionType NUT] selector:@selector(handleCollisionBee:withNut:)];
	[self handleAfterCollisionBetween:[CollisionType AIM_POLLEN] and:[CollisionType EDGE] selector:@selector(handleCollisionAimPollen:withEdge:)];
}

-(void) handleBeforeCollisionBetween:(CollisionType *)type1 and:(CollisionType *)type2 selector:(SEL)selector
{
	PhysicsSystem *physicsSystem = (PhysicsSystem *)[[_world systemManager] getSystem:[PhysicsSystem class]];
	[physicsSystem detectBeforeCollisionsBetween:type1 and:type2];
	
	CollisionMediator *mediator = [CollisionMediator mediatorWithType1:type1 type2:type2 selector:selector];
	[_collisionMediators addObject:mediator];
}

-(void) handleAfterCollisionBetween:(CollisionType *)type1 and:(CollisionType *)type2 selector:(SEL)selector
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
    BeeComponent *beeComponent = [BeeComponent getFrom:beeEntity];
    BeeType *beeType = [beeComponent type];
    
    DisposableComponent *rampDisposableComponent = [DisposableComponent getFrom:rampEntity];
    
    if (![rampDisposableComponent isDisposed] &&
        [beeType canDestroyRamp])
    {
		[rampDisposableComponent setIsDisposed:TRUE];
		
        [beeEntity deleteEntity];
        
		[EntityUtil animateAndDeleteEntity:rampEntity animationName:@"Ramp-Crash" disablePhysics:TRUE];
        
		[[SoundManager sharedManager] playSound:@"52144__blaukreuz__imp-02.m4a"];
    }
}

-(void) handleCollisionBee:(Entity *)beeEntity withBeeater:(Entity *)beeaterEntity
{   
    DisposableComponent *beeaterDisposableComponent = [DisposableComponent getFrom:beeaterEntity];
    
    if (![beeaterDisposableComponent isDisposed])
    {
		[beeaterDisposableComponent setIsDisposed:TRUE];
		
        [beeEntity deleteEntity];
		
		[EntityUtil animateDeleteAndSaveBeeFromBeeaterEntity:beeaterEntity];
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
    DisposableComponent *pollenDisposableComponent = [DisposableComponent getFrom:pollenEntity];
    
    if (![pollenDisposableComponent isDisposed])
    {
        [pollenDisposableComponent setIsDisposed:TRUE];
		
		[EntityUtil animateAndDeleteEntity:pollenEntity animationName:@"Pollen-Pickup" disablePhysics:TRUE];
    }
}

-(void)handleCollisionBee:(Entity *)beeEntity withMushroom:(Entity *)mushroomEntity
{
	RenderComponent *mushroomRenderComponent = [RenderComponent getFrom:mushroomEntity];
	if ([mushroomEntity hasComponent:[DisposableComponent class]])
	{
		DisposableComponent *mushroomDisposableComponent = [DisposableComponent getFrom:mushroomEntity];
		if (![mushroomDisposableComponent isDisposed])
		{
			[mushroomDisposableComponent setIsDisposed:TRUE];
			
			[EntityUtil animateAndDeleteEntity:mushroomEntity animationName:@"SmokeMushroom-BounceAndPuff" disablePhysics:FALSE];
			
			[[SoundManager sharedManager] playSound:@"11097__a43__a43-blipp.aif"];
		}
	}
	else
	{
		[mushroomRenderComponent playAnimationsLoopLast:[NSArray arrayWithObjects:@"Mushroom-Bounce", @"Mushroom-Idle", nil]];
		
		[[SoundManager sharedManager] playSound:@"11097__a43__a43-blipp.aif"];
	}
}

-(void)handleCollisionBee:(Entity *)beeEntity withWood:(Entity *)woodEntity
{
	DisposableComponent *woodDisposableComponent = [DisposableComponent getFrom:woodEntity];
	
	if (![woodDisposableComponent isDisposed])
	{
		BeeComponent *beeComponent = [BeeComponent getFrom:beeEntity];
		BeeType *beeType = [beeComponent type];
		
		if ([beeType canDestroyWood])
		{
			[woodDisposableComponent setIsDisposed:TRUE];
			
			[beeEntity deleteEntity];
			
			[EntityUtil animateAndDeleteEntity:woodEntity animationName:@"Wood-Destroy" disablePhysics:FALSE];
			
			[[SoundManager sharedManager] playSound:@"18339__jppi-stu__sw-paper-crumple-1.aiff"];
		}
	}
}

-(void) handleCollisionBee:(Entity *)beeEntity withNut:(Entity *)nutEntity
{
	DisposableComponent *nutDisposableComponent = [DisposableComponent getFrom:nutEntity];
	
	if (![nutDisposableComponent isDisposed])
	{
		[nutDisposableComponent setIsDisposed:TRUE];
		
		[beeEntity deleteEntity];
		
		[EntityUtil animateAndDeleteEntity:nutEntity animationName:@"Nut-Collect" disablePhysics:TRUE];
	}
}

-(void) handleCollisionAimPollen:(Entity *)aimPollenEntity withEdge:(Entity *)edgeEntity
{
    [aimPollenEntity deleteEntity];
}

@end
