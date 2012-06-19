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
	}

	// TODO: Tight coupling with captured system/component is not good
	if ([pulverizableEntity hasComponent:[CapturedComponent class]])
	{
		CapturedSystem *capturedSystem = (CapturedSystem *)[[_world systemManager] getSystem:[CapturedSystem class]];
		[capturedSystem saveContainedBee:pulverizableEntity];
	}

	PulverizableComponent *pulverizableComponent = [PulverizableComponent getFrom:pulverizableEntity];
	RenderComponent *renderComponent = [RenderComponent getFrom:pulverizableEntity];
	for (RenderSprite *renderSprite in [renderComponent renderSprites])
	{
		NSString *pulverAnimationName = [pulverizableComponent pulverAnimationForRenderSpriteName:[renderSprite name]];
		if (renderSprite == [[renderComponent renderSprites] lastObject])
		{
			[renderSprite playAnimationOnce:pulverAnimationName andCallBlockAtEnd:^{
				[pulverizableEntity deleteEntity];
			}];
		}
		else
		{
			[renderSprite playAnimationOnce:pulverAnimationName];
		}
	}

	return FALSE;
}

@end
