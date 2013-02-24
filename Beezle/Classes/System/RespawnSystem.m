//
// Created by Marcus on 04/12/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "RespawnSystem.h"
#import "NotificationProcessor.h"
#import "NotificationTypes.h"
#import "RespawnComponent.h"
#import "RespawnInfo.h"
#import "TransformComponent.h"
#import "EntityFactory.h"
#import "EntityUtil.h"
#import "RenderComponent.h"
#import "RenderSprite.h"

@interface RespawnSystem()

-(void) handleEntityDisposed:(NSNotification *)notification;

@end

@implementation RespawnSystem

-(id) init
{
	if (self = [super initWithUsedComponentClass:[RespawnComponent class]])
	{
		_notificationProcessor = [[NotificationProcessor alloc] initWithTarget:self];
		[_notificationProcessor registerNotification:GAME_NOTIFICATION_ENTITY_DISPOSED withSelector:@selector(handleEntityDisposed:)];

		_respawnInfos = [NSMutableArray new];
	}
	return self;
}

-(void) dealloc
{
	[_notificationProcessor release];
	[_respawnInfos release];

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
	NSMutableArray *respawnInfosToRemove = [NSMutableArray array];
	for (RespawnInfo *respawnInfo in _respawnInfos)
	{
		if ([respawnInfo hasCountdownReachedZero])
		{
			Entity *entity = [EntityFactory createEntity:[respawnInfo entityType] world:_world];
			[EntityUtil setEntityPosition:entity position:[respawnInfo position]];
			RenderComponent *renderComponent = [RenderComponent getFrom:entity];
			RenderSprite *renderSprite = [renderComponent firstRenderSprite];
			[renderSprite playAnimationsLoopLast:[NSArray arrayWithObjects:[respawnInfo respawnAnimationName], [renderSprite randomDefaultIdleAnimationName], nil]];

			[respawnInfosToRemove addObject:respawnInfo];
		}
		else
		{
			[respawnInfo decreaseCountdown];
		}
	}
	[_respawnInfos removeObjectsInArray:respawnInfosToRemove];

	[_notificationProcessor processNotifications];
}

-(void) handleEntityDisposed:(NSNotification *)notification
{
	Entity *entity = [[notification userInfo] objectForKey:@"entity"];
	if ([entity hasComponent:[RespawnComponent class]])
	{
		[self addRespawnInfoForEntity:entity];
	}
}

-(void) addRespawnInfoForEntity:(Entity *)entity
{
	RespawnComponent *respawnComponent = [RespawnComponent getFrom:entity];
	TransformComponent *transformComponent = [TransformComponent getFrom:entity];
	RespawnInfo *respawnInfo = [[[RespawnInfo alloc] initWithEntityType:[respawnComponent entityType] position:[transformComponent position] respawnAnimationName:[respawnComponent respawnAnimationName]] autorelease];
	[_respawnInfos addObject:respawnInfo];
}

@end
