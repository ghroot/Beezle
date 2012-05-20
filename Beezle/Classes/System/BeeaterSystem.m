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
-(void) animateBeeaterAndSaveContainedBee:(Entity *)beeaterEntity;
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
	RenderSprite *headRenderSprite = [renderComponent renderSpriteWithName:@"head"];
	NSString *headAnimationName = [NSString stringWithFormat:[beeaterComponent showBeeAnimationNameFormat], @"Idle", [[beeaterComponent containedBeeType] capitalizedString]];
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
		[self animateBeeaterAndSaveContainedBee:entity];
	}
}
		 
-(void) animateBeeaterAndSaveContainedBee:(Entity *)beeaterEntity
{
	TagManager *tagManager = (TagManager *)[[beeaterEntity world] getManager:[TagManager class]];
	Entity *slingerEntity = (Entity *)[tagManager getEntity:@"SLINGER"];
	BeeaterComponent *beeaterComponent = [BeeaterComponent getFrom:beeaterEntity];
	SlingerComponent *slingerComponent = [SlingerComponent getFrom:slingerEntity];
	BeeType *savedBeeType = [beeaterComponent containedBeeType];
	BeeType *savingBeeType = [beeaterComponent destroyedByBeeType];
	
	// Save bee
	if ([savedBeeType canBeReused])
	{
		[slingerComponent insertBeeTypeAtStart:savedBeeType];
	}
	else
	{
		[slingerComponent pushBeeType:savedBeeType];
	}
	
	// Reuse bee
	if (savingBeeType != nil &&
		[savingBeeType canBeReused])
	{
		[slingerComponent insertBeeTypeAtStart:[beeaterComponent destroyedByBeeType]];
	}
	
	// Notification
	TransformComponent *beeaterTransformComponent = [TransformComponent getFrom:beeaterEntity];
	NSMutableDictionary *notificationUserInfo = [NSMutableDictionary dictionary];
	[notificationUserInfo setObject:[NSValue valueWithCGPoint:[beeaterTransformComponent position]] forKey:@"entityPosition"];
	[notificationUserInfo setObject:savedBeeType forKey:@"savedBeeType"];
	if (savingBeeType != nil)
	{
		[notificationUserInfo setObject:savingBeeType forKey:@"savingBeeType"];
	}
	[[NSNotificationCenter defaultCenter] postNotificationName:GAME_NOTIFICATION_BEE_SAVED object:self userInfo:notificationUserInfo];
	
	// Destroy beeater
	RenderComponent *beeaterRenderComponent = (RenderComponent *)[beeaterEntity getComponent:[RenderComponent class]];
	RenderSprite *beeaterBodyRenderSprite = (RenderSprite *)[beeaterRenderComponent renderSpriteWithName:@"body"];
	RenderSprite *beeaterHeadRenderSprite = (RenderSprite *)[beeaterRenderComponent renderSpriteWithName:@"head"];
	[beeaterHeadRenderSprite hide];
	[beeaterBodyRenderSprite playDefaultDestroyAnimationAndCallBlockAtEnd:^{
		[beeaterEntity deleteEntity];
	}];
	
	// Disable physics
	[EntityUtil disablePhysics:beeaterEntity];
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
		RenderSprite *headRenderSprite = [renderComponent renderSpriteWithName:@"head"];
		NSString *headAnimationName = [NSString stringWithFormat:[beeaterComponent showBeeAnimationNameFormat], @"Still", [[beeaterComponent containedBeeType] capitalizedString]];
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
