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

-(void) handleBeforeCollisionBetween:(CollisionTypes *)type1 and:(CollisionTypes *)type2 selector:(SEL)selector;
-(void) handleAfterCollisionBetween:(CollisionTypes *)type1 and:(CollisionTypes *)type2 selector:(SEL)selector;
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
	[self handleAfterCollisionBetween:[CollisionTypes sharedTypeBee] and:[CollisionTypes sharedTypeBackground] selector:@selector(handleCollisionBee:withBackground:)];
	[self handleAfterCollisionBetween:[CollisionTypes sharedTypeBee] and:[CollisionTypes sharedTypeBeeater] selector:@selector(handleCollisionBee:withBeeater:)];
	[self handleAfterCollisionBetween:[CollisionTypes sharedTypeBee] and:[CollisionTypes sharedTypeEdge] selector:@selector(handleCollisionBee:withEdge:)];
	[self handleBeforeCollisionBetween:[CollisionTypes sharedTypeBee] and:[CollisionTypes sharedTypePollen] selector:@selector(handleCollisionBee:withPollen:)];
	[self handleAfterCollisionBetween:[CollisionTypes sharedTypeBee] and:[CollisionTypes sharedTypeRamp] selector:@selector(handleCollisionBee:withRamp:)];
	[self handleAfterCollisionBetween:[CollisionTypes sharedTypeBee] and:[CollisionTypes sharedTypeMushroom] selector:@selector(handleCollisionBee:withMushroom:)];
    [self handleAfterCollisionBetween:[CollisionTypes sharedTypeBee] and:[CollisionTypes sharedTypeWood] selector:@selector(handleCollisionBee:withWood:)];
	[self handleAfterCollisionBetween:[CollisionTypes sharedTypeBee] and:[CollisionTypes sharedTypeNut] selector:@selector(handleCollisionBee:withNut:)];
	[self handleAfterCollisionBetween:[CollisionTypes sharedTypeAimPollen] and:[CollisionTypes sharedTypeEdge] selector:@selector(handleCollisionAimPollen:withEdge:)];
}

-(void) handleBeforeCollisionBetween:(CollisionTypes *)type1 and:(CollisionTypes *)type2 selector:(SEL)selector
{
	PhysicsSystem *physicsSystem = (PhysicsSystem *)[[_world systemManager] getSystem:[PhysicsSystem class]];
	[physicsSystem detectBeforeCollisionsBetween:type1 and:type2];
	
	CollisionMediator *mediator = [CollisionMediator mediatorWithType1:type1 type2:type2 selector:selector];
	[_collisionMediators addObject:mediator];
}

-(void) handleAfterCollisionBetween:(CollisionTypes *)type1 and:(CollisionTypes *)type2 selector:(SEL)selector
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
		
        [beeEntity deleteEntity];
        
		[EntityUtil animateAndDeleteEntity:rampEntity animationName:@"Ramp-Crash"];
        
		[[SoundManager sharedManager] playSound:@"52144__blaukreuz__imp-02.m4a"];
    }
}

-(void) handleCollisionBee:(Entity *)beeEntity withBeeater:(Entity *)beeaterEntity
{   
    DisposableComponent *beeaterDisposableComponent = (DisposableComponent *)[beeaterEntity getComponent:[DisposableComponent class]];
    
    if (![beeaterDisposableComponent isDisposed])
    {
		[beeaterDisposableComponent setIsDisposed:TRUE];
		
        [beeEntity deleteEntity];
		
		[EntityUtil animateDeleteAndSaveBeeFromBeeaterEntity:beeaterEntity];
    }
}

-(void) handleCollisionBee:(Entity *)beeEntity withBackground:(Entity *)backgroundEntity
{
	BeeComponent *beeBeeComponent = (BeeComponent *)[beeEntity getComponent:[BeeComponent class]];
	if (![[beeBeeComponent type] canRoll])
	{
		[EntityUtil animateAndDeleteEntity:beeEntity animationName:@"Bee-Crash"];
	}
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
		
		[EntityUtil animateAndDeleteEntity:pollenEntity animationName:@"Pollen-Pickup"];
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
    
		[[SoundManager sharedManager] playSound:@"11097__a43__a43-blipp.aif"];
    }
}

-(void)handleCollisionBee:(Entity *)beeEntity withWood:(Entity *)woodEntity
{
	DisposableComponent *woodDisposableComponent = (DisposableComponent *)[woodEntity getComponent:[DisposableComponent class]];
	
	if (![woodDisposableComponent isDisposed])
	{
		BeeComponent *beeComponent = (BeeComponent *)[beeEntity getComponent:[BeeComponent class]];
		BeeTypes *beeType = [beeComponent type];
		
		if ([beeType canDestroyWood])
		{
			[woodDisposableComponent setIsDisposed:TRUE];
			
			[beeEntity deleteEntity];
			
			[EntityUtil animateAndDeleteEntity:woodEntity animationName:@"Wood-Destroy"];
			
			[[SoundManager sharedManager] playSound:@"18339__jppi-stu__sw-paper-crumple-1.aiff"];
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
		
		[EntityUtil animateAndDeleteEntity:nutEntity animationName:@"Nut-Collect"];
	}
}

-(void) handleCollisionAimPollen:(Entity *)aimPollenEntity withEdge:(Entity *)edgeEntity
{
    [aimPollenEntity deleteEntity];
}

@end
