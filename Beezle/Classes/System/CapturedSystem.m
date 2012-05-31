//
//  FrozenSystem.m
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

@interface CapturedSystem()

-(void) handleEntityDisposed:(NSNotification *)notification;
-(void) saveContainedBee:(Entity *)capturedEntity;

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

-(void) begin
{
	[_notificationProcessor processNotifications];
}

-(void) handleEntityDisposed:(NSNotification *)notification
{
	Entity *entity = [[notification userInfo] objectForKey:@"entity"];
	if ([entity hasComponent:[CapturedComponent class]])
	{
		[self saveContainedBee:entity];
	}
}

-(void) saveContainedBee:(Entity *)capturedEntity
{
	TagManager *tagManager = (TagManager *)[_world getManager:[TagManager class]];
	Entity *slingerEntity = [tagManager getEntity:@"SLINGER"];
	CapturedComponent *capturedComponent = [CapturedComponent getFrom:capturedEntity];
	SlingerComponent *slingerComponent = [SlingerComponent getFrom:slingerEntity];
	BeeType *savedBeeType = [capturedComponent containedBeeType];
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
	TransformComponent *capturedTransformComponent = [TransformComponent getFrom:capturedEntity];
	NSMutableDictionary *notificationUserInfo = [NSMutableDictionary dictionary];
	[notificationUserInfo setObject:[NSValue valueWithCGPoint:[capturedTransformComponent position]] forKey:@"entityPosition"];
	[notificationUserInfo setObject:savedBeeType forKey:@"savedBeeType"];
	if (savingBeeType != nil)
	{
		[notificationUserInfo setObject:savingBeeType forKey:@"savingBeeType"];
	}
	[[NSNotificationCenter defaultCenter] postNotificationName:GAME_NOTIFICATION_BEE_SAVED object:self userInfo:notificationUserInfo];
}

@end
