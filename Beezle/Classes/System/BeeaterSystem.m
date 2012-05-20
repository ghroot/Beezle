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
#import "EntityFactory.h"
#import "EntityUtil.h"
#import "NotificationProcessor.h"
#import "NotificationTypes.h"
#import "PhysicsComponent.h"
#import "RenderComponent.h"
#import "RenderSprite.h"
#import "SlingerComponent.h"
#import "SoundManager.h"
#import "StringList.h"
#import "TransformComponent.h"
#import "Utils.h"

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
}

-(void) begin
{
	[_notificationProcessor processNotifications];
}

-(void) animateBeeater:(Entity *)beeaterEntity
{
	RenderComponent *renderComponent = [RenderComponent getFrom:beeaterEntity];
	
	RenderSprite *bodyRenderSprite = [renderComponent renderSpriteWithName:@"body"];
	[bodyRenderSprite playDefaultIdleAnimation];
	
	BeeaterComponent *beeaterComponent = [BeeaterComponent getFrom:beeaterEntity];
	CapturedComponent *capturedComponent = [CapturedComponent getFrom:beeaterEntity];
	RenderSprite *headRenderSprite = [renderComponent renderSpriteWithName:@"head"];
	NSString *headAnimationName = [NSString stringWithFormat:[beeaterComponent showBeeAnimationNameFormat], @"Idle", [[capturedComponent containedBeeType] capitalizedString]];
	StringList *betweenAnimationNames = [beeaterComponent showBeeBetweenAnimationNames];
	NSString *firstBetweenAnimationName = [betweenAnimationNames randomString];
	NSString *secondBetweenAnimationName = [betweenAnimationNames randomString];
	[headRenderSprite playAnimationsLoopAll:[NSArray arrayWithObjects:firstBetweenAnimationName, headAnimationName, secondBetweenAnimationName, headAnimationName, nil]];
}

-(void) handleEntityDisposed:(NSNotification *)notification
{
	Entity *entity = [[notification userInfo] objectForKey:@"entity"];
	if ([entity hasComponent:[BeeaterComponent class]])
	{
		// Destroy beeater
		RenderComponent *beeaterRenderComponent = (RenderComponent *)[entity getComponent:[RenderComponent class]];
		RenderSprite *beeaterBodyRenderSprite = (RenderSprite *)[beeaterRenderComponent renderSpriteWithName:@"body"];
		RenderSprite *beeaterHeadRenderSprite = (RenderSprite *)[beeaterRenderComponent renderSpriteWithName:@"head"];
		[beeaterHeadRenderSprite hide];
		[beeaterBodyRenderSprite playDefaultDestroyAnimationAndCallBlockAtEnd:^{
			[entity deleteEntity];
		}];
		
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
		NSString *headAnimationName = [NSString stringWithFormat:[beeaterComponent showBeeAnimationNameFormat], @"Still", [[capturedComponent containedBeeType] capitalizedString]];
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
