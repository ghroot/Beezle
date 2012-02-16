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
#import "TransformComponent.h"

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
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queueNotification:) name:GAME_NOTIFICATION_BEEATER_CONTAINED_BEE_CHANGED object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queueNotification:) name:GAME_NOTIFICATION_BEEATER_KILLED object:nil];
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
		
		for (int i = 0; i < 10; i++)
		{
			CGPoint position = CGPointMake([transformComponent position].x - 40 + (rand() % 40), [transformComponent position].y - 40 + (rand() % 40));
			cpVect velocity = CGPointMake(-150 + (rand() % 300), -150 + (rand() % 300));
			
			Entity *glassPieceEntity = [EntityFactory createEntity:@"GLASS-PC" world:_world];
			[EntityUtil setEntityPosition:glassPieceEntity position:position];
			PhysicsComponent *glassPiecePhysicsComponent = [PhysicsComponent getFrom:glassPieceEntity];
			[[glassPiecePhysicsComponent body] setVel:velocity];
			
			RenderComponent *renderComponent = [RenderComponent getFrom:glassPieceEntity];
			RenderSprite *renderSprite = [[renderComponent renderSprites] objectAtIndex:0];
			
			int randomAnimationNumber = 1 + (rand() % 8);
			NSString *animationName = [NSString stringWithFormat:@"Glass-Pc%d-Idle", randomAnimationNumber];
			[renderSprite playAnimation:animationName];
			
			CCFadeOut *fadeOutAction = [CCFadeOut actionWithDuration:7.0f];
			CCCallFunc *callFunctionAction = [CCCallFunc actionWithTarget:glassPieceEntity selector:@selector(deleteEntity)];
			[[renderSprite sprite] runAction:[CCSequence actions:fadeOutAction, callFunctionAction, nil]];
		}
		
		[[DisposableComponent getFrom:entity] setIsDisposed:TRUE];
		[entity deleteEntity];
		
		
	}
}

@end
