//
//  FrozenSystem.m
//  Beezle
//
//  Created by KM Lagerstrom on 08/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FrozenSystem.h"
#import "EntityUtil.h"
#import "FrozenComponent.h"
#import "NotificationProcessor.h"
#import "NotificationTypes.h"
#import "RenderComponent.h"
#import "SlingerComponent.h"
#import "TransformComponent.h"

@interface FrozenSystem()

-(void) handleEntityDisposed:(NSNotification *)notification;
-(void) animateAndSaveContainedBee:(Entity *)frozenEntity;

@end

@implementation FrozenSystem

-(id) init
{
	if (self = [super initWithUsedComponentClass:[FrozenComponent class]])
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
	if ([entity hasComponent:[FrozenComponent class]])
	{
		[self animateAndSaveContainedBee:entity];
	}
}

-(void) animateAndSaveContainedBee:(Entity *)frozenEntity
{
	// Save bee
	TagManager *tagManager = (TagManager *)[[frozenEntity world] getManager:[TagManager class]];
	Entity *slingerEntity = (Entity *)[tagManager getEntity:@"SLINGER"];
	FrozenComponent *frozenComponent = [FrozenComponent getFrom:frozenEntity];
	SlingerComponent *slingerComponent = [SlingerComponent getFrom:slingerEntity];
	[slingerComponent pushBeeType:[frozenComponent containedBeeType]];
	
	// Swap bee sprite for hole graphics
	RenderComponent *frozenRenderComponent = [RenderComponent getFrom:frozenEntity];
	[frozenRenderComponent playDefaultDestroyAnimation];
	[EntityUtil disablePhysics:frozenEntity];
	
	// Game notification
	TransformComponent *transformComponent = [TransformComponent getFrom:frozenEntity];
	NSMutableDictionary *notificationUserInfo = [NSMutableDictionary dictionary];
	[notificationUserInfo setObject:[NSValue valueWithCGPoint:[transformComponent position]] forKey:@"entityPosition"];
	[notificationUserInfo setObject:[frozenComponent containedBeeType] forKey:@"beeType"];
	[[NSNotificationCenter defaultCenter] postNotificationName:GAME_NOTIFICATION_BEE_SAVED object:self userInfo:notificationUserInfo];
}

@end
