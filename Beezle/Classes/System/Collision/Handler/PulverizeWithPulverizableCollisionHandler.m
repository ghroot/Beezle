//
//  PulverizeWithPulverizableCollisionHandler.m
//  Beezle
//
//  Created by Marcus Lagerstrom on 06/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PulverizeWithPulverizableCollisionHandler.h"
#import "PulverizeComponent.h"
#import "PulverizableComponent.h"
#import "RenderSprite.h"
#import "RenderComponent.h"
#import "EntityUtil.h"
#import "CapturedComponent.h"
#import "CapturedSystem.h"
#import "DisposableComponent.h"

@implementation PulverizeWithPulverizableCollisionHandler

-(id) initWithWorld:(World *)world levelSession:(LevelSession *)levelSession
{
	if (self = [super initWithWorld:world levelSession:levelSession])
	{
		[_firstComponentClasses addObject:[PulverizeComponent class]];
		[_secondComponentClasses addObject:[PulverizableComponent class]];
	}
	return self;
}

-(BOOL) handleCollisionBetween:(Entity *)firstEntity and:(Entity *)secondEntity collision:(Collision *)collision
{
	Entity *pulverizableEntity = secondEntity;

	if ([EntityUtil isEntityDisposable:pulverizableEntity])
	{
		[EntityUtil setEntityDisposed:pulverizableEntity sendNotification:FALSE];
		[[DisposableComponent getFrom:pulverizableEntity] setIsAboutToBeDeleted:TRUE];
	}

	if ([pulverizableEntity hasComponent:[CapturedComponent class]])
	{
		CapturedSystem *capturedSystem = (CapturedSystem *)[[_world systemManager] getSystem:[CapturedSystem class]];
		[capturedSystem saveContainedBees:pulverizableEntity];
	}

	PulverizableComponent *pulverizableComponent = [PulverizableComponent getFrom:pulverizableEntity];
	RenderComponent *renderComponent = [RenderComponent getFrom:pulverizableEntity];
	BOOL wasCallbackScheduled = FALSE;
	for (RenderSprite *renderSprite in [renderComponent renderSprites])
	{
		NSString *pulverAnimationName = [pulverizableComponent pulverAnimationForRenderSpriteName:[renderSprite name]];
		if (pulverAnimationName != nil)
		{
			if (wasCallbackScheduled)
			{
				[renderSprite playAnimationOnce:pulverAnimationName];
			}
			else
			{
				[renderSprite playAnimationOnce:pulverAnimationName andCallBlockAtEnd:^{
					[pulverizableEntity deleteEntity];
				}];
				wasCallbackScheduled = TRUE;
			}
		}
		else
		{
			[renderSprite hide];
		}
	}

	return FALSE;
}

@end
