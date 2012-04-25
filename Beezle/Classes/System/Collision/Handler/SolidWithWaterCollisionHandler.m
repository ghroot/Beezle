//
//  SolidWithWaterCollisionHandler.m
//  Beezle
//
//  Created by KM Lagerstrom on 22/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SolidWithWaterCollisionHandler.h"
#import "EntityFactory.h"
#import "EntityUtil.h"
#import "RenderComponent.h"
#import "RenderSprite.h"
#import "SolidComponent.h"
#import "TransformComponent.h"
#import "WaterComponent.h"
#import "Waves1DNode.h"

@implementation SolidWithWaterCollisionHandler

-(id) initWithWorld:(World *)world levelSession:(LevelSession *)levelSession
{
	if (self = [super initWithWorld:world levelSession:levelSession])
	{
		[_firstComponentClasses addObject:[SolidComponent class]];
		[_secondComponentClasses addObject:[WaterComponent class]];
	}
	return self;
}

-(BOOL) handleCollisionBetween:(Entity *)firstEntity and:(Entity *)secondEntity collision:(Collision *)collision
{
	Entity *solidEntity = firstEntity;
	Entity *waterEntity = secondEntity;
	
	[EntityUtil destroyEntity:solidEntity instant:TRUE];
	
	WaterComponent *waterComponent = [WaterComponent getFrom:waterEntity];
	Entity *splashEntity = [EntityFactory createEntity:[waterComponent splashEntityType] world:_world];
	TransformComponent *transformComponent = [TransformComponent getFrom:firstEntity];
	CGPoint splashPosition = CGPointMake([transformComponent position].x, 8.0f);
	[EntityUtil setEntityPosition:splashEntity position:splashPosition];
	[EntityUtil destroyEntity:splashEntity];
	
	TransformComponent *solidTransformComponent = [TransformComponent getFrom:solidEntity];
	RenderComponent *waterRenderComponent = [RenderComponent getFrom:waterEntity];
	RenderSprite *renderSprite = [[waterRenderComponent renderSprites] objectAtIndex:0];
	CCSprite *sprite = [renderSprite sprite];
	for (Waves1DNode *wave in [sprite children])
	{
		[wave makeSplashAt:[solidTransformComponent position].x amount:3.0f];
	}
	
	return FALSE;
}

@end
