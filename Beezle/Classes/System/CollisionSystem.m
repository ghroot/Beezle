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
#import "EntityFactory.h"
#import "EntityUtil.h"
#import "GateComponent.h"
#import "LevelSession.h"
#import "NotificationTypes.h"
#import "PhysicsComponent.h"
#import "PhysicsSystem.h"
#import "RenderComponent.h"
#import "RenderSprite.h"
#import "SoundComponent.h"
#import "SoundManager.h"
#import "TransformComponent.h"
#import "Utils.h"

@interface CollisionSystem()

-(void) registerCollisionBetween:(CollisionType *)type1 and:(CollisionType *)type2 selector:(SEL)selector;
-(CollisionMediator *) findMediatorForCollision:(Collision *)collision;
-(void) handleCollisions;
-(void) handleCollisionBee:(Entity *)beeEntity withEdge:(Entity *)edgeEntity collision:(Collision *)collision;
-(void) handleCollisionBee:(Entity *)beeEntity withBackground:(Entity *)backgroundEntity collision:(Collision *)collision;
-(void) handleCollisionBee:(Entity *)beeEntity withBeeater:(Entity *)beeaterEntity collision:(Collision *)collision;
-(void) handleCollisionBee:(Entity *)beeEntity withPollen:(Entity *)pollenEntity collision:(Collision *)collision;
-(void) handleCollisionBee:(Entity *)beeEntity withMushroom:(Entity *)mushroomEntity collision:(Collision *)collision;
-(void) handleCollisionBee:(Entity *)beeEntity withWood:(Entity *)woodEntity collision:(Collision *)collision;
-(void) handleCollisionBee:(Entity *)beeEntity withNut:(Entity *)nutEntity collision:(Collision *)collision;
-(void) handleCollisionBee:(Entity *)beeEntity withEgg:(Entity *)eggEntity collision:(Collision *)collision;
-(void) handleCollisionBee:(Entity *)beeEntity withGlass:(Entity *)glassEntity collision:(Collision *)collision;
-(void) handleCollisionBee:(Entity *)beeEntity withGate:(Entity *)gateEntity collision:(Collision *)collision;
-(void) handleCollisionBee:(Entity *)beeEntity withWater:(Entity *)gateEntity collision:(Collision *)collision;
-(void) handleCollisionAimPollen:(Entity *)aimPollenEntity withEdge:(Entity *)edgeEntity collision:(Collision *)collision;
-(void) handleCollisionGlassPiece:(Entity *)glassPieceEntity withEntity:(Entity *)otherEntity collision:(Collision *)collision;
-(void) handleCollisionWaterdrop:(Entity *)waterdropEntity withBackground:(Entity *)backgroundEntity collision:(Collision *)collision;

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
	[self registerCollisionBetween:[CollisionType BEE] and:[CollisionType EDGE] selector:@selector(handleCollisionBee:withEdge:collision:)];
	[self registerCollisionBetween:[CollisionType BEE] and:[CollisionType BACKGROUND] selector:@selector(handleCollisionBee:withBackground:collision:)];
	[self registerCollisionBetween:[CollisionType BEE] and:[CollisionType BEEATER] selector:@selector(handleCollisionBee:withBeeater:collision:)];
	[self registerCollisionBetween:[CollisionType BEE] and:[CollisionType POLLEN] selector:@selector(handleCollisionBee:withPollen:collision:)];
	[self registerCollisionBetween:[CollisionType BEE] and:[CollisionType MUSHROOM] selector:@selector(handleCollisionBee:withMushroom:collision:)];
    [self registerCollisionBetween:[CollisionType BEE] and:[CollisionType WOOD] selector:@selector(handleCollisionBee:withWood:collision:)];
	[self registerCollisionBetween:[CollisionType BEE] and:[CollisionType NUT] selector:@selector(handleCollisionBee:withNut:collision:)];
	[self registerCollisionBetween:[CollisionType BEE] and:[CollisionType EGG] selector:@selector(handleCollisionBee:withEgg:collision:)];
	[self registerCollisionBetween:[CollisionType BEE] and:[CollisionType GLASS] selector:@selector(handleCollisionBee:withGlass:collision:)];
	[self registerCollisionBetween:[CollisionType BEE] and:[CollisionType GATE] selector:@selector(handleCollisionBee:withGate:collision:)];
	[self registerCollisionBetween:[CollisionType BEE] and:[CollisionType WATER] selector:@selector(handleCollisionBee:withWater:collision:)];
	[self registerCollisionBetween:[CollisionType AIM_POLLEN] and:[CollisionType EDGE] selector:@selector(handleCollisionAimPollen:withEdge:collision:)];
	[self registerCollisionBetween:[CollisionType GLASS_PIECE] and:[CollisionType BACKGROUND] selector:@selector(handleCollisionGlassPiece:withEntity:collision:)];
	[self registerCollisionBetween:[CollisionType GLASS_PIECE] and:[CollisionType EDGE] selector:@selector(handleCollisionGlassPiece:withEntity:collision:)];
	[self registerCollisionBetween:[CollisionType WATER_DROP] and:[CollisionType BACKGROUND] selector:@selector(handleCollisionWaterdrop:withBackground:collision:)];
}

-(void) registerCollisionBetween:(CollisionType *)type1 and:(CollisionType *)type2 selector:(SEL)selector
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

-(void) handleCollisionBee:(Entity *)beeEntity withEdge:(Entity *)edgeEntity collision:(Collision *)collision
{
    [EntityUtil setEntityDisposed:beeEntity];
	[beeEntity deleteEntity];
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
    if (![EntityUtil isEntityDisposed:beeaterEntity])
    {
        [EntityUtil setEntityDisposed:beeaterEntity];
		
		NSDictionary *notificationUserInfo = [NSDictionary dictionaryWithObject:beeaterEntity forKey:@"beeaterEntity"];
		[[NSNotificationCenter defaultCenter] postNotificationName:GAME_NOTIFICATION_BEEATER_HIT object:self userInfo:notificationUserInfo];

		BeeComponent *beeComponent = [BeeComponent getFrom:beeEntity];
		[beeComponent decreaseBeeaterHitsLeft];
		if ([beeComponent isOutOfBeeaterKills])
		{
            [EntityUtil setEntityDisposed:beeEntity];
            [EntityUtil animateAndDeleteEntity:beeEntity disablePhysics:TRUE];
		}
    }
}

-(void) handleCollisionBee:(Entity *)beeEntity withPollen:(Entity *)pollenEntity collision:(Collision *)collision
{
    if (![EntityUtil isEntityDisposed:pollenEntity])
    {
        [EntityUtil setEntityDisposed:pollenEntity];
		[_levelSession consumedEntity:pollenEntity];
        [EntityUtil animateAndDeleteEntity:pollenEntity];
    }
}

-(void) handleCollisionBee:(Entity *)beeEntity withMushroom:(Entity *)mushroomEntity collision:(Collision *)collision
{
    if ([EntityUtil isEntityDisposable:mushroomEntity])
	{
        if (![EntityUtil isEntityDisposed:mushroomEntity])
		{
            [EntityUtil setEntityDisposed:mushroomEntity];
            [EntityUtil animateAndDeleteEntity:mushroomEntity disablePhysics:FALSE];
            [EntityUtil playDefaultDestroySound:mushroomEntity];
		}
	}
	else
	{
		[[RenderComponent getFrom:mushroomEntity] playAnimationsLoopLast:[NSArray arrayWithObjects:@"Mushroom-Bounce", @"Mushroom-Idle", nil]];
		[[SoundManager sharedManager] playSound:@"11097__a43__a43-blipp.aif"];
	}
}

-(void) handleCollisionBee:(Entity *)beeEntity withWood:(Entity *)woodEntity collision:(Collision *)collision
{
    if (![EntityUtil isEntityDisposed:woodEntity])
	{
		BeeComponent *beeComponent = [BeeComponent getFrom:beeEntity];
		if ([beeComponent type] == [BeeType SAWEE])
		{
            [EntityUtil setEntityDisposed:woodEntity];
            [EntityUtil animateAndDeleteEntity:woodEntity];
			
            [EntityUtil setEntityDisposed:beeEntity];
			[beeEntity deleteEntity];
			
			[[SoundManager sharedManager] playSound:@"18339__jppi-stu__sw-paper-crumple-1.aiff"];
		}
	}
}

-(void) handleCollisionBee:(Entity *)beeEntity withNut:(Entity *)nutEntity collision:(Collision *)collision
{
    if (![EntityUtil isEntityDisposed:nutEntity])
	{
        [EntityUtil setEntityDisposed:nutEntity];
		[_levelSession consumedEntity:nutEntity];
		[[PhysicsComponent getFrom:nutEntity] disable];
		[nutEntity refresh];
        [[RenderComponent getFrom:nutEntity] playDefaultDestroyAnimation];
        [EntityUtil playDefaultDestroySound:nutEntity];
		
        [EntityUtil setEntityDisposed:beeEntity];
        [EntityUtil animateAndDeleteEntity:beeEntity];
	}
}

-(void) handleCollisionBee:(Entity *)beeEntity withEgg:(Entity *)eggEntity collision:(Collision *)collision
{
    if (![EntityUtil isEntityDisposed:eggEntity])
	{
        [EntityUtil setEntityDisposed:eggEntity];
		[_levelSession consumedEntity:eggEntity];
        [EntityUtil animateAndDeleteEntity:eggEntity];
		
        [EntityUtil setEntityDisposed:beeEntity];
        [EntityUtil animateAndDeleteEntity:beeEntity];
	}
}

-(void) handleCollisionBee:(Entity *)beeEntity withGlass:(Entity *)glassEntity collision:(Collision *)collision
{
	[[SoundManager sharedManager] playSound:@"BeeHitGlass"];
}

-(void) handleCollisionBee:(Entity *)beeEntity withGate:(Entity *)gateEntity collision:(Collision *)collision
{
	GateComponent *gateComponent = [GateComponent getFrom:gateEntity];
	if ([gateComponent isOpened])
	{
        [EntityUtil setEntityDisposed:beeEntity];
		[beeEntity deleteEntity];
		
		[_levelSession setDidUseKey:TRUE];
		
		// Game notification
		NSMutableDictionary *notificationUserInfo = [NSMutableDictionary dictionary];
		[notificationUserInfo setObject:[gateComponent hiddenLevelName] forKey:@"hiddenLevelName"];
		[[NSNotificationCenter defaultCenter] postNotificationName:GAME_NOTIFICATION_GATE_ENTERED object:self userInfo:notificationUserInfo];
	}
}

-(void) handleCollisionBee:(Entity *)beeEntity withWater:(Entity *)waterEntity collision:(Collision *)collision
{
	Entity *splashEntity = [EntityFactory createSimpleAnimatedEntity:_world animationFile:@"Bees-Animations.plist"];
	TransformComponent *beeTransformComponent = [TransformComponent getFrom:beeEntity];
	[EntityUtil setEntityPosition:splashEntity position:[beeTransformComponent position]];
	[EntityUtil animateAndDeleteEntity:splashEntity animationName:@"Bee-Splash"];
	
	[beeEntity deleteEntity];
}

-(void) handleCollisionAimPollen:(Entity *)aimPollenEntity withEdge:(Entity *)edgeEntity collision:(Collision *)collision
{
    if (![EntityUtil isEntityDisposed:aimPollenEntity])
    {
        [EntityUtil setEntityDisposed:aimPollenEntity];
        [aimPollenEntity deleteEntity];
    }
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
	
    [EntityUtil playDefaultDestroySound:glassPieceEntity];
}

-(void) handleCollisionWaterdrop:(Entity *)waterdropEntity withBackground:(Entity *)backgroundEntity collision:(Collision *)collision
{
	if (![EntityUtil isEntityDisposed:waterdropEntity])
	{
		[EntityUtil setEntityDisposed:waterdropEntity];
		[waterdropEntity deleteEntity];
		
		Entity *splashEntity = [EntityFactory createSimpleAnimatedEntity:_world];
		TransformComponent *transforComponent = [TransformComponent getFrom:waterdropEntity];
		[EntityUtil setEntityPosition:splashEntity position:[transforComponent position]];
		[EntityUtil animateAndDeleteEntity:splashEntity animationName:@"Waterdrop-Splash"];
		
		NSString *soundName = [NSString stringWithFormat:@"DripSmall%d", (1 + (rand() % 2))];
		[[SoundManager sharedManager] playSound:soundName];
	}
}

@end
