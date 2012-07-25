//
//  WoodSystem.m
//  Beezle
//
//  Created by KM Lagerstrom on 15/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WoodSystem.h"
#import "EntityUtil.h"
#import "NotificationProcessor.h"
#import "NotificationTypes.h"
#import "NSObject+PWObject.h"
#import "RenderComponent.h"
#import "RenderSprite.h"
#import "WoodComponent.h"
#import "DisposableComponent.h"

#define DELAY_PER_WOOD_PIECE 0.3f

@interface WoodSystem()

-(void) handleEntityDisposed:(NSNotification *)notification;

@end

@implementation WoodSystem

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
	[_woodComponentMapper release];
	[_renderComponentMapper release];
	[_disposableComponentMapper release];

	[_notificationProcessor release];
	
	[super dealloc];
}

-(void) initialise
{
	_woodComponentMapper = [[ComponentMapper alloc] initWithEntityManager:[_world entityManager] componentClass:[WoodComponent class]];
	_renderComponentMapper = [[ComponentMapper alloc] initWithEntityManager:[_world entityManager] componentClass:[RenderComponent class]];
	_disposableComponentMapper = [[ComponentMapper alloc] initWithEntityManager:[_world entityManager] componentClass:[DisposableComponent class]];
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
	if ([_woodComponentMapper hasEntityComponent:entity])
	{
		WoodComponent *woodComponent = [_woodComponentMapper getComponentFor:entity];
		if ([woodComponent shapeIndexAtSawCollision] >= 0)
		{
			RenderComponent *renderComponent = [_renderComponentMapper getComponentFor:entity];
			NSArray *woodRenderSprites = [renderComponent renderSprites];

			int numberOfStepsDown = [woodComponent shapeIndexAtSawCollision];
			int numberOfStepsUp = [woodRenderSprites count] - [woodComponent shapeIndexAtSawCollision] - 1;
			int downIndexForLastStep = -1;
			int upIndexForLastStep = -1;
			if (numberOfStepsDown >= numberOfStepsUp)
			{
				downIndexForLastStep = 0;
			}
			else
			{
				upIndexForLastStep = [woodRenderSprites count] - 1;
			}

			for (int i = [woodComponent shapeIndexAtSawCollision]; i >= 0; i--)
			{
				RenderSprite *renderSprite = [woodRenderSprites objectAtIndex:i];
				int stepsFromStart = [woodComponent shapeIndexAtSawCollision] - i;
				if (i == downIndexForLastStep)
				{
					[self performBlock:^(void){
						[renderSprite playAnimationOnce:[woodComponent randomSawedAnimationName] andCallBlockAtEnd:^{
							[entity deleteEntity];
						}];
					} afterDelay:stepsFromStart * DELAY_PER_WOOD_PIECE];
				}
				else
				{
					[self performBlock:^(void){
						[renderSprite playAnimationOnce:[woodComponent randomSawedAnimationName]];
					} afterDelay:stepsFromStart * DELAY_PER_WOOD_PIECE];
				}
			}
			for (int i = [woodComponent shapeIndexAtSawCollision] + 1; i < [woodRenderSprites count]; i++)
			{
				RenderSprite *renderSprite = [woodRenderSprites objectAtIndex:i];
				int stepsFromStart = i - [woodComponent shapeIndexAtSawCollision];
				if (i == upIndexForLastStep)
				{
					[self performBlock:^(void){
						[renderSprite playAnimationOnce:[woodComponent randomSawedAnimationName] andCallBlockAtEnd:^{
							[entity deleteEntity];
						}];
					} afterDelay:stepsFromStart * DELAY_PER_WOOD_PIECE];
				}
				else
				{
					[self performBlock:^(void){
						[renderSprite playAnimationOnce:[woodComponent randomSawedAnimationName]];
					} afterDelay:stepsFromStart * DELAY_PER_WOOD_PIECE];
				}
			}

			[EntityUtil disablePhysics:entity];

			if ([_disposableComponentMapper hasEntityComponent:entity])
			{
				[[_disposableComponentMapper getComponentFor:entity] setIsAboutToBeDeleted:TRUE];
			}
		}
		else
		{
			[EntityUtil destroyEntity:entity];
		}
	}
}

@end
