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
#import "EntityFactory.h"
#import "EntityUtil.h"
#import "GateComponent.h"
#import "LevelSession.h"
#import "NotificationTypes.h"
#import "PhysicsComponent.h"
#import "PhysicsSystem.h"
#import "PlayerInformation.h"
#import "RenderComponent.h"
#import "RenderSprite.h"
#import "SlingerComponent.h"
#import "SoundManager.h"
#import "TagManager.h"
#import "TransformComponent.h"
#import "Utils.h"

@interface CollisionSystem()

-(void) handleCollisionBetween:(CollisionType *)type1 and:(CollisionType *)type2 selector:(SEL)selector;
-(CollisionMediator *) findMediatorForCollision:(Collision *)collision;
-(void) handleCollisions;
-(void) handleCollisionBee:(Entity *)beeEntity withBackground:(Entity *)backgroundEntity collision:(Collision *)collision;
-(void) handleCollisionBee:(Entity *)beeEntity withBeeater:(Entity *)beeaterEntity collision:(Collision *)collision;
-(void) handleCollisionBee:(Entity *)beeEntity withEdge:(Entity *)edgeEntity collision:(Collision *)collision;
-(void) handleCollisionBee:(Entity *)beeEntity withPollen:(Entity *)pollenEntity collision:(Collision *)collision;
-(void) handleCollisionBee:(Entity *)beeEntity withPollenOrange:(Entity *)pollenOrangeEntity collision:(Collision *)collision;
-(void) handleCollisionBee:(Entity *)beeEntity withMushroom:(Entity *)mushroomEntity collision:(Collision *)collision;
-(void) handleCollisionBee:(Entity *)beeEntity withWood:(Entity *)woodEntity collision:(Collision *)collision;
-(void) handleCollisionBee:(Entity *)beeEntity withNut:(Entity *)nutEntity collision:(Collision *)collision;
-(void) handleCollisionBee:(Entity *)beeEntity withEgg:(Entity *)eggEntity collision:(Collision *)collision;
-(void) handleCollisionBee:(Entity *)beeEntity withGlass:(Entity *)glassEntity collision:(Collision *)collision;
-(void) handleCollisionBee:(Entity *)beeEntity withGate:(Entity *)gateEntity collision:(Collision *)collision;
-(void) handleCollisionAimPollen:(Entity *)aimPollenEntity withEdge:(Entity *)edgeEntity collision:(Collision *)collision;
-(void) handleCollisionGlassPiece:(Entity *)glassPieceEntity withEntity:(Entity *)otherEntity collision:(Collision *)collision;

@end

@implementation CollisionSystem

-(id) initWithLevelSession:(LevelSession *)levelSession
{
	if (self = [super init])
	{
		_collisionMediators = [[NSMutableArray alloc] init];
        _collisions = [[NSMutableArray alloc] init];
		_levelSession = levelSession;
	}
	return self;
}

-(id) init
{
    self = [self initWithLevelSession:nil];
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
	[self handleCollisionBetween:[CollisionType BEE] and:[CollisionType BACKGROUND] selector:@selector(handleCollisionBee:withBackground:collision:)];
	[self handleCollisionBetween:[CollisionType BEE] and:[CollisionType BEEATER] selector:@selector(handleCollisionBee:withBeeater:collision:)];
	[self handleCollisionBetween:[CollisionType BEE] and:[CollisionType EDGE] selector:@selector(handleCollisionBee:withEdge:collision:)];
	[self handleCollisionBetween:[CollisionType BEE] and:[CollisionType POLLEN] selector:@selector(handleCollisionBee:withPollen:collision:)];
	[self handleCollisionBetween:[CollisionType BEE] and:[CollisionType POLLEN_ORANGE] selector:@selector(handleCollisionBee:withPollenOrange:collision:)];
	[self handleCollisionBetween:[CollisionType BEE] and:[CollisionType MUSHROOM] selector:@selector(handleCollisionBee:withMushroom:collision:)];
    [self handleCollisionBetween:[CollisionType BEE] and:[CollisionType WOOD] selector:@selector(handleCollisionBee:withWood:collision:)];
	[self handleCollisionBetween:[CollisionType BEE] and:[CollisionType NUT] selector:@selector(handleCollisionBee:withNut:collision:)];
	[self handleCollisionBetween:[CollisionType BEE] and:[CollisionType EGG] selector:@selector(handleCollisionBee:withEgg:collision:)];
	[self handleCollisionBetween:[CollisionType BEE] and:[CollisionType GLASS] selector:@selector(handleCollisionBee:withGlass:collision:)];
	[self handleCollisionBetween:[CollisionType BEE] and:[CollisionType GATE] selector:@selector(handleCollisionBee:withGate:collision:)];
	[self handleCollisionBetween:[CollisionType AIM_POLLEN] and:[CollisionType EDGE] selector:@selector(handleCollisionAimPollen:withEdge:collision:)];
	[self handleCollisionBetween:[CollisionType GLASS_PIECE] and:[CollisionType BACKGROUND] selector:@selector(handleCollisionGlassPiece:withEntity:collision:)];
	[self handleCollisionBetween:[CollisionType GLASS_PIECE] and:[CollisionType EDGE] selector:@selector(handleCollisionGlassPiece:withEntity:collision:)];
}

-(void) handleCollisionBetween:(CollisionType *)type1 and:(CollisionType *)type2 selector:(SEL)selector
{
	PhysicsSystem *physicsSystem = (PhysicsSystem *)[[_world systemManager] getSystem:[PhysicsSystem class]];
	[physicsSystem detectCollisionsBetween:type1 and:type2];
	
	CollisionMediator *mediator = [CollisionMediator mediatorWithType1:type1 type2:type2 target:self selector:selector];
	[_collisionMediators addObject:mediator];
}

-(CollisionMediator *) findMediatorForCollision:(Collision *)collision
{
	for (CollisionMediator *mediator in _collisionMediators)
	{
        if ([mediator appliesForCollision:collision])
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
        NSAssert(mediator != nil, @"Collision mediator should always exist.");
        [mediator mediateCollision:collision];
    }
    [_collisions removeAllObjects];    
}
	 
-(void) handleCollisionBee:(Entity *)beeEntity withBackground:(Entity *)backgroundEntity collision:(Collision *)collision
{
	if ([collision impulseLength] >= 50)
	{
		[[SoundManager sharedManager] playSound:@"BeeHitWall"];
	}
}

-(void) handleCollisionBee:(Entity *)beeEntity withBeeater:(Entity *)beeaterEntity collision:(Collision *)collision
{  
    DisposableComponent *beeaterDisposableComponent = [DisposableComponent getFrom:beeaterEntity];
    if (![beeaterDisposableComponent isDisposed])
    {
		[beeaterDisposableComponent setIsDisposed:TRUE];
		
		NSDictionary *notificationUserInfo = [NSDictionary dictionaryWithObject:beeaterEntity forKey:@"beeaterEntity"];
		[[NSNotificationCenter defaultCenter] postNotificationName:GAME_NOTIFICATION_BEEATER_HIT object:self userInfo:notificationUserInfo];

		BeeComponent *beeComponent = [BeeComponent getFrom:beeEntity];
		[beeComponent decreaseBeeaterHitsLeft];
		if ([beeComponent isOutOfBeeaterKills])
		{
			[[DisposableComponent getFrom:beeEntity] setIsDisposed:TRUE];
			[EntityUtil animateAndDeleteEntity:beeEntity animationName:@"Bee-Crash" disablePhysics:TRUE];
		}
    }
}

-(void) handleCollisionBee:(Entity *)beeEntity withEdge:(Entity *)edgeEntity collision:(Collision *)collision
{
	[[DisposableComponent getFrom:beeEntity] setIsDisposed:TRUE];
	[beeEntity deleteEntity];
}

-(void) handleCollisionBee:(Entity *)beeEntity withPollen:(Entity *)pollenEntity collision:(Collision *)collision
{
    DisposableComponent *pollenDisposableComponent = [DisposableComponent getFrom:pollenEntity];
    if (![pollenDisposableComponent isDisposed])
    {
        [pollenDisposableComponent setIsDisposed:TRUE];
		[_levelSession consumedEntity:pollenEntity];
		[EntityUtil animateAndDeleteEntity:pollenEntity animationName:@"Pollen-Pickup" disablePhysics:TRUE];
    }
}

-(void) handleCollisionBee:(Entity *)beeEntity withPollenOrange:(Entity *)pollenOrangeEntity collision:(Collision *)collision
{
    DisposableComponent *pollenDisposableComponent = [DisposableComponent getFrom:pollenOrangeEntity];
    if (![pollenDisposableComponent isDisposed])
    {
        [pollenDisposableComponent setIsDisposed:TRUE];
		[_levelSession consumedEntity:pollenOrangeEntity];
		[EntityUtil animateAndDeleteEntity:pollenOrangeEntity animationName:@"PollenO-Pickup" disablePhysics:TRUE];
    }
}

-(void) handleCollisionBee:(Entity *)beeEntity withMushroom:(Entity *)mushroomEntity collision:(Collision *)collision
{
	RenderComponent *mushroomRenderComponent = [RenderComponent getFrom:mushroomEntity];
	if ([mushroomEntity hasComponent:[DisposableComponent class]])
	{
		DisposableComponent *mushroomDisposableComponent = [DisposableComponent getFrom:mushroomEntity];
		if (![mushroomDisposableComponent isDisposed])
		{
			[mushroomDisposableComponent setIsDisposed:TRUE];
			[EntityUtil animateAndDeleteEntity:mushroomEntity animationName:@"SmokeMushroom-BounceAndPuff" disablePhysics:FALSE];
			
			[[SoundManager sharedManager] playSound:@"SmokeMushroom"];
		}
	}
	else
	{
		[mushroomRenderComponent playAnimationsLoopLast:[NSArray arrayWithObjects:@"Mushroom-Bounce", @"Mushroom-Idle", nil]];
		
		[[SoundManager sharedManager] playSound:@"11097__a43__a43-blipp.aif"];
	}
}

-(void) handleCollisionBee:(Entity *)beeEntity withWood:(Entity *)woodEntity collision:(Collision *)collision
{
	DisposableComponent *woodDisposableComponent = [DisposableComponent getFrom:woodEntity];
	if (![woodDisposableComponent isDisposed])
	{
		BeeComponent *beeComponent = [BeeComponent getFrom:beeEntity];
		if ([beeComponent type] == [BeeType SAWEE])
		{
			[woodDisposableComponent setIsDisposed:TRUE];
			[EntityUtil animateAndDeleteEntity:woodEntity animationName:@"Wood-Destroy" disablePhysics:FALSE];
			
			[[DisposableComponent getFrom:beeEntity] setIsDisposed:TRUE];
			[beeEntity deleteEntity];
			
			[[SoundManager sharedManager] playSound:@"18339__jppi-stu__sw-paper-crumple-1.aiff"];
		}
	}
}

-(void) handleCollisionBee:(Entity *)beeEntity withNut:(Entity *)nutEntity collision:(Collision *)collision
{
	DisposableComponent *nutDisposableComponent = [DisposableComponent getFrom:nutEntity];
	if (![nutDisposableComponent isDisposed])
	{
		[nutDisposableComponent setIsDisposed:TRUE];
		[_levelSession consumedEntity:nutEntity];
		[EntityUtil animateAndDeleteEntity:nutEntity animationName:@"Nut-Collect" disablePhysics:TRUE];
		
		[[DisposableComponent getFrom:beeEntity] setIsDisposed:TRUE];
		[beeEntity deleteEntity];
		
		[[SoundManager sharedManager] playSound:@"BonusKey"];
	}
}

-(void) handleCollisionBee:(Entity *)beeEntity withEgg:(Entity *)eggEntity collision:(Collision *)collision
{
	DisposableComponent *eggDisposableComponent = [DisposableComponent getFrom:eggEntity];
	if (![eggDisposableComponent isDisposed])
	{
		[eggDisposableComponent setIsDisposed:TRUE];
		[_levelSession consumedEntity:eggEntity];
		[EntityUtil animateAndDeleteEntity:eggEntity animationName:@"Egg-Collect" disablePhysics:TRUE];
		
		[[DisposableComponent getFrom:beeEntity] setIsDisposed:TRUE];
		[beeEntity deleteEntity];
	}
}

-(void) handleCollisionBee:(Entity *)beeEntity withGlass:(Entity *)glassEntity collision:(Collision *)collision
{
	[[SoundManager sharedManager] playSound:@"BeeHitGlass"];
}

-(void) handleCollisionBee:(Entity *)beeEntity withGate:(Entity *)gateEntity
{
	GateComponent *gateComponent = [GateComponent getFrom:gateEntity];
	if ([gateComponent isOpened])
	{
		[[DisposableComponent getFrom:beeEntity] setIsDisposed:TRUE];
		[beeEntity deleteEntity];
		
		[_levelSession setDidUseKey:TRUE];
		
		// Game notification
		NSMutableDictionary *notificationUserInfo = [NSMutableDictionary dictionary];
		[notificationUserInfo setObject:[gateComponent hiddenLevelName] forKey:@"hiddenLevelName"];
		[[NSNotificationCenter defaultCenter] postNotificationName:GAME_NOTIFICATION_GATE_ENTERED object:self userInfo:notificationUserInfo];
	}
}

-(void) handleCollisionAimPollen:(Entity *)aimPollenEntity withEdge:(Entity *)edgeEntity collision:(Collision *)collision
{
	[[DisposableComponent getFrom:aimPollenEntity] setIsDisposed:TRUE];
    [aimPollenEntity deleteEntity];
}

-(void) handleCollisionGlassPiece:(Entity *)glassPieceEntity withEntity:(Entity *)otherEntity collision:(Collision *)collision
{
	TransformComponent *transformComponent = [TransformComponent getFrom:glassPieceEntity];
	PhysicsComponent *physicsComponent = [PhysicsComponent getFrom:glassPieceEntity];
	for (int i = 0; i < 3; i++)
	{
		// Create entity
		Entity *glassPieceSmallEntity = [EntityFactory createEntity:@"GLASS-PC-SMALL" world:_world];
		
		// Position
		[EntityUtil setEntityPosition:glassPieceSmallEntity position:[transformComponent position]];
		
		// Velocity
		PhysicsComponent *smallPhysicsComponent = [PhysicsComponent getFrom:glassPieceSmallEntity];
		cpVect randomVelocity = [Utils createVectorWithRandomAngleAndLengthBetween:20 and:50];
		cpVect summedVelocity = cpv([[physicsComponent body] vel].x + randomVelocity.x, [[physicsComponent body] vel].y + randomVelocity.y);
		[[smallPhysicsComponent body] setVel:summedVelocity];
		
		// Animation
		RenderComponent *smallRenderComponent = [RenderComponent getFrom:glassPieceSmallEntity];
		NSString *animationName = [NSString stringWithFormat:@"Glass-Pc%d-Idle", (1 + (rand() % 8))];
		[[smallRenderComponent firstRenderSprite] playAnimation:animationName];
		
		// Fade out
		[EntityUtil fadeOutAndDeleteEntity:glassPieceSmallEntity duration:4.0f];
	}
	[glassPieceEntity deleteEntity];
	
	[[SoundManager sharedManager] playSound:@"GlassSmall"];
}

@end
