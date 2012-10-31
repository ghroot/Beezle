//
//  BeeaterAnimationSystem.m
//  Beezle
//
//  Created by KM Lagerstrom on 09/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BeeaterSystem.h"
#import "BeeaterComponent.h"
#import "CapturedComponent.h"
#import "EntityUtil.h"
#import "NotificationProcessor.h"
#import "NotificationTypes.h"
#import "RenderComponent.h"
#import "RenderSprite.h"

static const float MINIMUM_BODY_ANIMATION_SPEED = 0.7f;
static const float MAXIMUM_BODY_ANIMATION_SPEED = 1.2f;

@interface BeeaterSystem()

-(void) handleEntityDisposed:(NSNotification *)notification;
-(void) handleEntityFrozen:(NSNotification *)notification;
-(void) handleEntityUnfrozen:(NSNotification *)notification;

@end

@implementation BeeaterSystem

-(id) init
{
	if (self = [super initWithUsedComponentClass:[BeeaterComponent class]])
	{
		_notificationProcessor = [[NotificationProcessor alloc] initWithTarget:self];
		[_notificationProcessor registerNotification:GAME_NOTIFICATION_ENTITY_DISPOSED withSelector:@selector(handleEntityDisposed:)];
		[_notificationProcessor registerNotification:GAME_NOTIFICATION_ENTITY_FROZEN withSelector:@selector(handleEntityFrozen:)];
		[_notificationProcessor registerNotification:GAME_NOTIFICATION_ENTITY_UNFROZEN withSelector:@selector(handleEntityUnfrozen:)];
	}
	return self;
}

-(void) dealloc
{
	[_beeaterComponentMapper release];
	[_renderComponentMapper release];
	[_capturedComponentMapper release];

	[_notificationProcessor release];
	
	[super dealloc];
}

-(void) initialise
{
	_beeaterComponentMapper = [[ComponentMapper alloc] initWithEntityManager:[_world entityManager] componentClass:[BeeaterComponent class]];
	_renderComponentMapper = [[ComponentMapper alloc] initWithEntityManager:[_world entityManager] componentClass:[RenderComponent class]];
	_capturedComponentMapper = [[ComponentMapper alloc] initWithEntityManager:[_world entityManager] componentClass:[CapturedComponent class]];
}

-(void) activate
{
	[super activate];
	
	[_notificationProcessor activate];
}

-(void) deactivate
{
	[super deactivate];
	
	[_notificationProcessor deactivate];
}

-(void) entityAdded:(Entity *)entity
{
	[self animateBeeater:entity];

	BeeaterComponent *beeaterComponent = [_beeaterComponentMapper getComponentFor:entity];
	if ([beeaterComponent randomSynchronisedBodyAnimationName] != nil &&
		[beeaterComponent randomSynchronisedHeadAnimationName] != nil)
	{
		[beeaterComponent resetSynchronisedAnimationCountdown];
	}
}

-(void) begin
{
	[_notificationProcessor processNotifications];
}

-(void) processEntity:(Entity *)entity
{
	BeeaterComponent *beeaterComponent = [_beeaterComponentMapper getComponentFor:entity];
	if (![beeaterComponent hasSynchronisedAnimationCountdownReachedZero])
	{
		[beeaterComponent decreaseSynchronisedAnimationCountdown];
		if ([beeaterComponent hasSynchronisedAnimationCountdownReachedZero])
		{
			if (![EntityUtil isEntityDisposed:entity])
			{
				RenderComponent *renderComponent = [_renderComponentMapper getComponentFor:entity];

				RenderSprite *bodyRenderSprite = [renderComponent renderSpriteWithName:@"body"];
				[bodyRenderSprite playAnimationOnce:[beeaterComponent randomSynchronisedBodyAnimationName] andCallBlockAtEnd:^{
					[self animateBeeater:entity];
					[beeaterComponent resetSynchronisedAnimationCountdown];
				}];

				RenderSprite *headRenderSprite = [renderComponent renderSpriteWithName:@"head"];
				[headRenderSprite playAnimationOnce:[beeaterComponent randomSynchronisedHeadAnimationName]];
			}
			else
			{
				[beeaterComponent resetSynchronisedAnimationCountdown];
			}
		}
	}
}

-(void) animateBeeater:(Entity *)beeaterEntity
{
	RenderComponent *renderComponent = [_renderComponentMapper getComponentFor:beeaterEntity];

	RenderSprite *bodyRenderSprite = [renderComponent renderSpriteWithName:@"body"];
	[bodyRenderSprite playDefaultIdleAnimation];
	float randomAnimationSpeed = MINIMUM_BODY_ANIMATION_SPEED + ((rand() % 100) / 100.0f) * (MAXIMUM_BODY_ANIMATION_SPEED - MINIMUM_BODY_ANIMATION_SPEED);
	[bodyRenderSprite setAnimationSpeed:randomAnimationSpeed];

	BeeaterComponent *beeaterComponent = [_beeaterComponentMapper getComponentFor:beeaterEntity];
	CapturedComponent *capturedComponent = [_capturedComponentMapper getComponentFor:beeaterEntity];
	RenderSprite *headRenderSprite = [renderComponent renderSpriteWithName:@"head"];
	NSString *headAnimationName = [beeaterComponent headAnimationNameForBeeType:[capturedComponent containedBeeType] string:@"Idle"];
	NSString *firstBetweenAnimationName = [beeaterComponent randomBetweenHeadAnimationName];
	NSString *secondBetweenAnimationName = [beeaterComponent randomBetweenHeadAnimationName];
	[headRenderSprite playAnimationsLoopAll:[NSArray arrayWithObjects:firstBetweenAnimationName, headAnimationName, secondBetweenAnimationName, headAnimationName, nil]];
}

-(void) handleEntityDisposed:(NSNotification *)notification
{
	Entity *entity = [[notification userInfo] objectForKey:@"entity"];
	if ([entity hasComponent:[BeeaterComponent class]])
	{
		// Destroy beeater
		RenderComponent *beeaterRenderComponent = [_renderComponentMapper getComponentFor:entity];
		RenderSprite *beeaterBodyRenderSprite = [beeaterRenderComponent renderSpriteWithName:@"body"];
		RenderSprite *beeaterHeadRenderSprite = [beeaterRenderComponent renderSpriteWithName:@"head"];
		[beeaterHeadRenderSprite hide];
		if ([beeaterBodyRenderSprite hasDefaultDestroyAnimation])
		{
			[beeaterBodyRenderSprite playDefaultDestroyAnimationAndCallBlockAtEnd:^{
				[entity deleteEntity];
			}];
		}
		else
		{
			[entity deleteEntity];
		}
		
		// Disable physics
		[EntityUtil disablePhysics:entity];
	}
}

-(void) handleEntityFrozen:(NSNotification *)notification
{
	Entity *entity = [[notification userInfo] objectForKey:@"entity"];
	if ([entity hasComponent:[BeeaterComponent class]])
	{
		RenderComponent *renderComponent = [_renderComponentMapper getComponentFor:entity];

		RenderSprite *bodyRenderSprite = [renderComponent renderSpriteWithName:@"body"];
		[bodyRenderSprite playDefaultStillAnimation];
		
		BeeaterComponent *beeaterComponent = [_beeaterComponentMapper getComponentFor:entity];
		CapturedComponent *capturedComponent = [_capturedComponentMapper getComponentFor:entity];
		RenderSprite *headRenderSprite = [renderComponent renderSpriteWithName:@"head"];
		NSString *headAnimationName = [beeaterComponent headAnimationNameForBeeType:[capturedComponent containedBeeType] string:@"Still"];
		[headRenderSprite playAnimationLoop:headAnimationName];
	}
}

-(void) handleEntityUnfrozen:(NSNotification *)notification
{
	Entity *entity = [[notification userInfo] objectForKey:@"entity"];
	if ([entity hasComponent:[BeeaterComponent class]])
	{
		[self animateBeeater:entity];
	}
}

@end
