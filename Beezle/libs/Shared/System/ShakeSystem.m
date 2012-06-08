//
//  ShakeSystem.m
//  Beezle
//
//  Created by KM Lagerstrom on 21/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShakeSystem.h"
#import "NotificationProcessor.h"
#import "NotificationTypes.h"
#import "RenderComponent.h"
#import "RenderSprite.h"
#import "ShakeComponent.h"

#define NUMBER_OF_SHAKES 15
#define SHAKE_MAX_DISTANCE 8
#define DELAY_BETWEEN_SHAKES 0.05f

@interface ShakeSystem()

-(void) handleEntityDisposed:(NSNotification *)notification;

@end

@implementation ShakeSystem

-(id) init
{
	if (self = [super init])
	{
		_notificationProcessor = [[NotificationProcessor alloc] initWithTarget:self];
		[_notificationProcessor registerNotification:GAME_NOTIFICATION_ENTITY_DISPOSED withSelector:@selector(handleEntityDisposed:)];
	}
	return self;
}

-(void) dealloc
{
	[_shakeComponentMapper release];
	[_renderComponentMapper release];

	[_notificationProcessor release];
	
	[super dealloc];
}

-(void) initialise
{
	_shakeComponentMapper = [[ComponentMapper alloc] initWithEntityManager:[_world entityManager] componentClass:[ShakeComponent class]];
	_renderComponentMapper = [[ComponentMapper alloc] initWithEntityManager:[_world entityManager] componentClass:[RenderComponent class]];
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
	if ([_shakeComponentMapper hasEntityComponent:entity])
	{
		RenderComponent *renderComponent = [_renderComponentMapper getComponentFor:entity];

		NSMutableArray *actions = [NSMutableArray arrayWithCapacity:NUMBER_OF_SHAKES];
		for (int i = 0; i < NUMBER_OF_SHAKES; i++)
		{
			CCCallBlock *callBlockAction1 = [CCCallBlock actionWithBlock:^{
				CGPoint offset;
				offset.x = -SHAKE_MAX_DISTANCE + rand() % (2 * SHAKE_MAX_DISTANCE);
				offset.y = -SHAKE_MAX_DISTANCE + rand() % (2 * SHAKE_MAX_DISTANCE);
				for (RenderSprite *renderSprite in [renderComponent renderSprites])
				{
					[renderSprite setOffset:offset];
				}
			}];
			[actions addObject:callBlockAction1];
			
			CCDelayTime *delayTimeAction = [CCDelayTime actionWithDuration:DELAY_BETWEEN_SHAKES];
			[actions addObject:delayTimeAction];
		}
		
		CCCallBlock *callBlockAction2 = [CCCallBlock actionWithBlock:^{
			for (RenderSprite *renderSprite in [renderComponent renderSprites])
			{
				[renderSprite setOffset:CGPointZero];
			}
		}];
		[actions addObject:callBlockAction2];
		
		CCSequence *sequenceAction = [CCSequence actionWithArray:actions];
		[[[CCDirector sharedDirector] actionManager] addAction:sequenceAction target:self paused:FALSE];
	}
}

@end
