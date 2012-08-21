//
//  SawWithWoodCollisionHandler.m
//  Beezle
//
//  Created by KM Lagerstrom on 22/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SawWithWoodCollisionHandler.h"
#import "Collision.h"
#import "EntityUtil.h"
#import "PhysicsComponent.h"
#import "SawComponent.h"
#import "WoodComponent.h"
#import "RenderComponent.h"
#import "NSObject+PWObject.h"
#import "RenderSprite.h"
#import "SoundManager.h"

static const float DELAY_PER_WOOD_PIECE = 0.3f;

@interface SawWithWoodCollisionHandler()

-(void) playWoodPieceAnimation:(Entity *)woodEntity renderSprite:(RenderSprite *)renderSprite animationName:(NSString *)animationName delete:(BOOL)delete delay:(float)delay;

@end

@implementation SawWithWoodCollisionHandler

-(id) initWithWorld:(World *)world levelSession:(LevelSession *)levelSession
{
	if (self = [super initWithWorld:world levelSession:levelSession])
	{
		[_firstComponentClasses addObject:[SawComponent class]];
		[_secondComponentClasses addObject:[WoodComponent class]];
	}
	return self;
}

-(BOOL) handleCollisionBetween:(Entity *)firstEntity and:(Entity *)secondEntity collision:(Collision *)collision
{
	Entity *sawEntity = firstEntity;
	Entity *woodEntity = secondEntity;
	
	[EntityUtil destroyEntity:sawEntity instant:TRUE];
	
	WoodComponent *woodComponent = [WoodComponent getFrom:woodEntity];
	PhysicsComponent *physicsComponent = [PhysicsComponent getFrom:woodEntity];
	int shapeIndexAtCollision = [[physicsComponent shapes] indexOfObject:[collision secondShape]];

	if (shapeIndexAtCollision >= 0)
	{
		RenderComponent *renderComponent = [RenderComponent getFrom:woodEntity];
		NSArray *woodRenderSprites = [renderComponent renderSprites];

		int numberOfStepsDown = shapeIndexAtCollision;
		int numberOfStepsUp = [woodRenderSprites count] - shapeIndexAtCollision - 1;
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

		for (int i = shapeIndexAtCollision; i >= 0; i--)
		{
			RenderSprite *renderSprite = [woodRenderSprites objectAtIndex:i];
			int stepsFromStart = shapeIndexAtCollision - i;
			[self playWoodPieceAnimation:woodEntity renderSprite:renderSprite animationName:[woodComponent randomSawedAnimationName] delete:(i == downIndexForLastStep) delay:(stepsFromStart * DELAY_PER_WOOD_PIECE)];
		}
		for (int i = shapeIndexAtCollision + 1; i < [woodRenderSprites count]; i++)
		{
			RenderSprite *renderSprite = [woodRenderSprites objectAtIndex:i];
			int stepsFromStart = i - shapeIndexAtCollision;
			[self playWoodPieceAnimation:woodEntity renderSprite:renderSprite animationName:[woodComponent randomSawedAnimationName] delete:(i == upIndexForLastStep) delay:(stepsFromStart * DELAY_PER_WOOD_PIECE)];
		}

		[EntityUtil disablePhysics:woodEntity];
	}
	else
	{
		[EntityUtil destroyEntity:woodEntity];
	}

	[EntityUtil setEntityIsAboutToBeDeleted:woodEntity];

	[[SoundManager sharedManager] playSound:@"WoodDestroy"];

	return FALSE;
}

-(void) playWoodPieceAnimation:(Entity *)woodEntity renderSprite:(RenderSprite *)renderSprite animationName:(NSString *)animationName delete:(BOOL)delete delay:(float)delay
{
	if (delete)
	{
		if (delay == 0.0f)
		{
			[renderSprite playAnimationOnce:animationName andCallBlockAtEnd:^{
				[woodEntity deleteEntity];
			}];
		}
		else
		{
			[self performBlock:^(void){
				[renderSprite playAnimationOnce:animationName andCallBlockAtEnd:^{
					[woodEntity deleteEntity];
				}];
			} afterDelay:delay];
		}
	}
	else
	{
		if (delay == 0.0f)
		{
			[renderSprite playAnimationOnce:animationName];
		}
		else
		{
			[self performBlock:^(void){
				[renderSprite playAnimationOnce:animationName];
			} afterDelay:delay];
		}
	}
}

@end
