//
//  BeeaterAnimationSystem.m
//  Beezle
//
//  Created by KM Lagerstrom on 09/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BeeaterSystem.h"
#import "BeeaterComponent.h"
#import "EntityFactory.h"
#import "EntityUtil.h"
#import "NotificationTypes.h"
#import "PhysicsComponent.h"
#import "RenderComponent.h"
#import "RenderSprite.h"
#import "SlingerComponent.h"
#import "SoundManager.h"
#import "TransformComponent.h"
#import "Utils.h"

@interface BeeaterSystem()

-(void) addNotificationObservers;
-(void) queueNotification:(NSNotification *)notification;
-(void) handleNotification:(NSNotification *)notification;
-(void) handleBeeaterBeeChanged:(NSNotification *)notification;
-(void) handleBeeaterHit:(NSNotification *)notification;
-(void) handleEntityCrumbled:(NSNotification *)notification;
-(void) animateBeeaterAndSaveContainedBee:(Entity *)beeaterEntity;

@end

@implementation BeeaterSystem

-(id) init
{
	if (self = [super init])
	{
		_notifications = [[NSMutableArray alloc] init];
		[self addNotificationObservers];
	}
	return self;
}

-(void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[_notifications release];
	
	[super dealloc];
}

-(void) addNotificationObservers
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queueNotification:) name:GAME_NOTIFICATION_BEEATER_CONTAINED_BEE_CHANGED object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queueNotification:) name:GAME_NOTIFICATION_BEEATER_HIT object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queueNotification:) name:GAME_NOTIFICATION_ENTITY_CRUMBLED object:nil];
}

-(void) queueNotification:(NSNotification *)notification
{
	[_notifications addObject:notification];
}

-(void) begin
{
	while ([_notifications count] > 0)
	{
		NSNotification *nextNotification = [[_notifications objectAtIndex:0] retain];
		[_notifications removeObjectAtIndex:0];
		[self handleNotification:nextNotification];
		[nextNotification release];
	}
}

-(void) handleNotification:(NSNotification *)notification
{
	if ([[notification name] isEqualToString:GAME_NOTIFICATION_BEEATER_CONTAINED_BEE_CHANGED])
	{
		[self handleBeeaterBeeChanged:notification];
	}
	else if ([[notification name] isEqualToString:GAME_NOTIFICATION_BEEATER_HIT])
	{
		[self handleBeeaterHit:notification];
	}
	else if ([[notification name] isEqualToString:GAME_NOTIFICATION_ENTITY_CRUMBLED])
	{
		[self handleEntityCrumbled:notification];
	}
}

-(void) handleBeeaterBeeChanged:(NSNotification *)notification
{
	BeeaterComponent *beeaterComponent = [notification object];
	Entity *beeaterEntity = [beeaterComponent parentEntity];
	RenderComponent *renderComponent = [RenderComponent getFrom:beeaterEntity];
	RenderSprite *headRenderSprite = [renderComponent getRenderSprite:@"head"];
	NSString *headAnimationName = [NSString stringWithFormat:@"Beeater-Head-Idle-With%@", [[beeaterComponent containedBeeType] capitalizedString]];
    [headRenderSprite playAnimation:headAnimationName];
}

-(void) handleBeeaterHit:(NSNotification *)notification
{
	Entity *beeaterEntity = [[notification userInfo] objectForKey:@"beeaterEntity"];
	[self animateBeeaterAndSaveContainedBee:beeaterEntity];
}

-(void) handleEntityCrumbled:(NSNotification *)notification
{
	Entity *entity = [[notification userInfo] objectForKey:@"entity"];
	if ([entity hasComponent:[BeeaterComponent class]])
	{
		[self animateBeeaterAndSaveContainedBee:entity];
	}
}
		 
-(void) animateBeeaterAndSaveContainedBee:(Entity *)beeaterEntity
{
	// Save bee
	TagManager *tagManager = (TagManager *)[[beeaterEntity world] getManager:[TagManager class]];
	Entity *slingerEntity = (Entity *)[tagManager getEntity:@"SLINGER"];
	BeeaterComponent *beeaterComponent = (BeeaterComponent *)[beeaterEntity getComponent:[BeeaterComponent class]];
	SlingerComponent *slingerComponent = (SlingerComponent *)[slingerEntity getComponent:[SlingerComponent class]];
	[slingerComponent pushBeeType:[beeaterComponent containedBeeType]];
	
	// Destroy beeater
	TransformComponent *beeaterTransformComponent = (TransformComponent *)[beeaterEntity getComponent:[TransformComponent class]];
	RenderComponent *beeaterRenderComponent = (RenderComponent *)[beeaterEntity getComponent:[RenderComponent class]];
	RenderSprite *beeaterBodyRenderSprite = (RenderSprite *)[beeaterRenderComponent getRenderSprite:@"body"];
	RenderSprite *beeaterHeadRenderSprite = (RenderSprite *)[beeaterRenderComponent getRenderSprite:@"head"];
	[beeaterHeadRenderSprite hide];
	[beeaterBodyRenderSprite playAnimation:[beeaterComponent killAnimationName] withCallbackTarget:beeaterEntity andCallbackSelector:@selector(deleteEntity)];
	
	// Disable physics
	PhysicsComponent *beeaterPhysicsComponent = [PhysicsComponent getFrom:beeaterEntity];
	[beeaterPhysicsComponent disable];
	[beeaterEntity refresh];
	
	// Particles
	for (int i = 0; i < 8; i++)
	{
		// Create entity
		Entity *particleEntity = [EntityFactory createEntity:@"BEEATER-PC4" world:_world];
		
		// Position
		CGPoint topLeft = CGPointMake([beeaterTransformComponent position].x - 15,
									  [beeaterTransformComponent position].y + 5);
		CGPoint randomPosition = CGPointMake(topLeft.x + (rand() % 30),
											 topLeft.y + (rand() % 30));
		[EntityUtil setEntityPosition:particleEntity position:randomPosition];
		
		// Velocity
		PhysicsComponent *particlePhysicsComponent = [PhysicsComponent getFrom:particleEntity];
		cpVect randomVelocity = [Utils createVectorWithRandomAngleAndLengthBetween:40 and:80];
		[[particlePhysicsComponent body] setVel:randomVelocity];
		
		// Animation
		[EntityUtil animateAndDeleteEntity:particleEntity disablePhysics:FALSE];
	}
	
	// Game notification
	NSMutableDictionary *notificationUserInfo = [NSMutableDictionary dictionary];
	[notificationUserInfo setObject:[NSValue valueWithCGPoint:[beeaterTransformComponent position]] forKey:@"beeaterEntityPosition"];
	[notificationUserInfo setObject:[beeaterComponent containedBeeType] forKey:@"beeType"];
	[[NSNotificationCenter defaultCenter] postNotificationName:GAME_NOTIFICATION_BEE_SAVED object:self userInfo:notificationUserInfo];
	
    [EntityUtil playDefaultDestroySound:beeaterEntity];
}

@end
