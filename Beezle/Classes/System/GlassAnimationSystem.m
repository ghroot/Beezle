//
//  GlassAnimationSystem.m
//  Beezle
//
//  Created by KM Lagerstrom on 16/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GlassAnimationSystem.h"
#import "DisposableComponent.h"
#import "EntityFactory.h"
#import "EntityUtil.h"
#import "GlassComponent.h"
#import "NotificationTypes.h"
#import "PhysicsComponent.h"
#import "RenderComponent.h"
#import "RenderSprite.h"
#import "SoundManager.h"
#import "TransformComponent.h"
#import "Utils.h"

#define PIECES_MIN_VELOCITY 50
#define PIECES_MAX_VELOCITY 100

@interface GlassAnimationSystem()

-(void) addNotificationObservers;
-(void) queueNotification:(NSNotification *)notification;
-(void) handleNotification:(NSNotification *)notification;
-(void) handleEntityCrumbled:(NSNotification *)notification;

@end

@implementation GlassAnimationSystem

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
	if ([[notification name] isEqualToString:GAME_NOTIFICATION_ENTITY_CRUMBLED])
	{
		[self handleEntityCrumbled:notification];
	}
}

-(void) handleEntityCrumbled:(NSNotification *)notification
{
	Entity *entity = [[notification userInfo] objectForKey:@"entity"];
	if ([entity hasComponent:[GlassComponent class]])
	{
		TransformComponent *transformComponent = [TransformComponent getFrom:entity];
		GlassComponent *glassComponent = [GlassComponent getFrom:entity];
		for (int i = 0; i < [glassComponent piecesCount]; i++)
		{
			// Create entity
			Entity *glassPieceEntity = [EntityFactory createEntity:@"GLASS-PC" world:_world];
			
			// Position
			CGPoint centerPoint = CGPointMake(
						[transformComponent position].x + [glassComponent piecesSpawnAreaOffset].x,
						[transformComponent position].y + [glassComponent piecesSpawnAreaOffset].y);
			CGPoint topLeft = CGPointMake(
						centerPoint.x - [glassComponent piecesSpawnAreaSize].width / 2,
										  centerPoint.y - [glassComponent piecesSpawnAreaSize].height / 2);
			CGPoint randomPosition = CGPointMake(
						topLeft.x + (rand() % (int)[glassComponent piecesSpawnAreaSize].width),
						topLeft.y + (rand() % (int)[glassComponent piecesSpawnAreaSize].height));
			[EntityUtil setEntityPosition:glassPieceEntity position:randomPosition];
			
			// Velocity
			PhysicsComponent *glassPiecePhysicsComponent = [PhysicsComponent getFrom:glassPieceEntity];
			cpVect randomVelocity = [Utils createVectorWithRandomAngleAndLengthBetween:PIECES_MIN_VELOCITY and:PIECES_MAX_VELOCITY];
			[[glassPiecePhysicsComponent body] setVel:randomVelocity];
			
			// Animation
			RenderComponent *renderComponent = [RenderComponent getFrom:glassPieceEntity];
			NSString *animationName = [NSString stringWithFormat:@"Glass-Pc%d-Idle", (1 + (rand() % 8))];
			[[renderComponent firstRenderSprite] playAnimation:animationName];
			
			// Fade out
			[EntityUtil fadeOutAndDeleteEntity:glassPieceEntity duration:7.0f];
		}
		
		[[DisposableComponent getFrom:entity] setIsDisposed:TRUE];
		[entity deleteEntity];
		
		[[SoundManager sharedManager] playSound:@"GlassLarge"];
	}
}

@end
