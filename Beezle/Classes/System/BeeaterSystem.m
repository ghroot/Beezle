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
	[_notificationProcessor release];
	
	[super dealloc];
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

	BeeaterComponent *beeaterComponent = [BeeaterComponent getFrom:entity];
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
	BeeaterComponent *beeaterComponent = [BeeaterComponent getFrom:entity];
	if (![beeaterComponent hasSynchronisedAnimationCountdownReachedZero])
	{
		[beeaterComponent decreaseSynchronisedAnimationCountdown];
		if ([beeaterComponent hasSynchronisedAnimationCountdownReachedZero])
		{
			RenderComponent *renderComponent = [RenderComponent getFrom:entity];

			RenderSprite *bodyRenderSprite = [renderComponent renderSpriteWithName:@"body"];
			[bodyRenderSprite playAnimationOnce:[beeaterComponent randomSynchronisedBodyAnimationName] andCallBlockAtEnd:^{
				[self animateBeeater:entity];
				[beeaterComponent resetSynchronisedAnimationCountdown];
			}];

			RenderSprite *headRenderSprite = [renderComponent renderSpriteWithName:@"head"];
			[headRenderSprite playAnimationOnce:[beeaterComponent randomSynchronisedHeadAnimationName]];
		}
	}
}

-(void) animateBeeater:(Entity *)beeaterEntity
{
	RenderComponent *renderComponent = [RenderComponent getFrom:beeaterEntity];
	
	RenderSprite *bodyRenderSprite = [renderComponent renderSpriteWithName:@"body"];
	[bodyRenderSprite playDefaultIdleAnimation];
	
	BeeaterComponent *beeaterComponent = [BeeaterComponent getFrom:beeaterEntity];
	CapturedComponent *capturedComponent = [CapturedComponent getFrom:beeaterEntity];
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
		RenderComponent *beeaterRenderComponent = (RenderComponent *)[entity getComponent:[RenderComponent class]];
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
		RenderComponent *renderComponent = [RenderComponent getFrom:entity];
		
		RenderSprite *bodyRenderSprite = [renderComponent renderSpriteWithName:@"body"];
		[bodyRenderSprite playDefaultStillAnimation];
		
		BeeaterComponent *beeaterComponent = [BeeaterComponent getFrom:entity];
		CapturedComponent *capturedComponent = [CapturedComponent getFrom:entity];
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
