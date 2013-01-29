//
//  CapturedSystem.m
//  Beezle
//
//  Created by KM Lagerstrom on 08/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CapturedSystem.h"
#import "CapturedComponent.h"
#import "NotificationProcessor.h"
#import "NotificationTypes.h"
#import "RenderComponent.h"
#import "SlingerComponent.h"
#import "TransformComponent.h"
#import "SoundManager.h"

@interface CapturedSystem()

-(void) handleEntityDisposed:(NSNotification *)notification;
-(void) saveContainedBee:(Entity *)capturedEntity savedBeeType:(BeeType *)savedBeeType;

@end

@implementation CapturedSystem

-(id) init
{
	if (self = [super initWithUsedComponentClass:[CapturedComponent class]])
	{
		_notificationProcessor = [[NotificationProcessor alloc] initWithTarget:self];
		[_notificationProcessor registerNotification:GAME_NOTIFICATION_ENTITY_DISPOSED withSelector:@selector(handleEntityDisposed:)];
	}
	return self;
}

-(void) dealloc
{
	[_capturedComponentMapper release];
	[_slingerComponentMapper release];
	[_transformComponentMapper release];

	[_notificationProcessor release];
	
	[super dealloc];
}

-(void) initialise
{
	_capturedComponentMapper = [[ComponentMapper alloc] initWithEntityManager:[_world entityManager] componentClass:[CapturedComponent class]];
	_slingerComponentMapper = [[ComponentMapper alloc] initWithEntityManager:[_world entityManager] componentClass:[SlingerComponent class]];
	_transformComponentMapper = [[ComponentMapper alloc] initWithEntityManager:[_world entityManager] componentClass:[TransformComponent class]];
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

-(void) begin
{
	[_notificationProcessor processNotifications];
}

-(void) handleEntityDisposed:(NSNotification *)notification
{
	Entity *entity = [[notification userInfo] objectForKey:@"entity"];
	if ([_capturedComponentMapper hasEntityComponent:entity])
	{
		[self saveContainedBees:entity];
	}
}

-(void) saveContainedBees:(Entity *)capturedEntity
{
	CapturedComponent *capturedComponent = [_capturedComponentMapper getComponentFor:capturedEntity];
	for (BeeType *containedBeeType in [capturedComponent containedBeeTypes])
	{
		[self saveContainedBee:capturedEntity savedBeeType:containedBeeType];
	}
}

-(void) saveContainedBee:(Entity *)capturedEntity savedBeeType:(BeeType *)savedBeeType
{
	TagManager *tagManager = (TagManager *)[_world getManager:[TagManager class]];
	Entity *slingerEntity = [tagManager getEntity:@"SLINGER"];
	CapturedComponent *capturedComponent = [_capturedComponentMapper getComponentFor:capturedEntity];
	SlingerComponent *slingerComponent = [_slingerComponentMapper getComponentFor:slingerEntity];
	BeeType *savingBeeType = [capturedComponent destroyedByBeeType];
	
	if ([savedBeeType canBeReused] &&
		[savingBeeType canBeReused])
	{
		CCLOG(@"WARNING: Both saved and saving bee can not be reusable");
	}
	
	// Save bee
//	if ([savedBeeType canBeReused])
//	{
//		[slingerComponent insertBeeTypeAtStart:savedBeeType];
//	}
//	else
//	{
		[slingerComponent pushBeeType:savedBeeType];
//	}
	
	// Reuse bee
	if (savingBeeType != nil &&
		[savingBeeType canBeReused])
	{
//		[slingerComponent insertBeeTypeAtStart:savingBeeType];
		[slingerComponent pushBeeType:savingBeeType];
	}
	
	// Notification
	TransformComponent *capturedTransformComponent = [_transformComponentMapper getComponentFor:capturedEntity];
	NSMutableDictionary *notificationUserInfo = [NSMutableDictionary dictionary];
	[notificationUserInfo setObject:[NSValue valueWithCGPoint:[capturedTransformComponent position]] forKey:@"entityPosition"];
	[notificationUserInfo setObject:savedBeeType forKey:@"savedBeeType"];
	if (savingBeeType != nil)
	{
		[notificationUserInfo setObject:savingBeeType forKey:@"savingBeeType"];
	}
	[[NSNotificationCenter defaultCenter] postNotificationName:GAME_NOTIFICATION_BEE_SAVED object:self userInfo:notificationUserInfo];

	if (![[savedBeeType freedSoundName] isEqualToString:@""])
	{
		[[SoundManager sharedManager] playSound:[savedBeeType freedSoundName]];
	}
}

@end
