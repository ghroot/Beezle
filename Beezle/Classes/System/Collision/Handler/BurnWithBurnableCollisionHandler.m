//
// Created by Marcus on 17/02/2013.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "BurnWithBurnableCollisionHandler.h"
#import "EntityUtil.h"
#import "DisposableComponent.h"
#import "CapturedComponent.h"
#import "CapturedSystem.h"
#import "PollenComponent.h"
#import "PollenSystem.h"
#import "RenderComponent.h"
#import "SoundManager.h"
#import "RenderSprite.h"
#import "BurnableComponent.h"
#import "BurnComponent.h"
#import "RenderSystem.h"
#import "ZOrder.h"
#import "EntityFactory.h"
#import "PhysicsComponent.h"
#import "RespawnComponent.h"
#import "RespawnSystem.h"

@implementation BurnWithBurnableCollisionHandler

-(id) initWithWorld:(World *)world levelSession:(LevelSession *)levelSession
{
	if (self = [super initWithWorld:world levelSession:levelSession])
	{
		[_firstComponentClasses addObject:[BurnComponent class]];
		[_secondComponentClasses addObject:[BurnableComponent class]];
	}
	return self;
}

-(BOOL) handleCollisionBetween:(Entity *)firstEntity and:(Entity *)secondEntity collision:(Collision *)collision
{
	Entity *burnableEntity = secondEntity;
	BurnableComponent *burnableComponent = [BurnableComponent getFrom:burnableEntity];

	if ([[burnableComponent burnRenderSpritesByName] count] == 0)
	{
		// A burnable entity with no burn render sprites defined will simply be destroyed (like 'Glass' and 'Ice')
		[EntityUtil destroyEntity:burnableEntity];
	}
	else
	{
		[EntityUtil disablePhysics:burnableEntity];

		if ([EntityUtil isEntityDisposable:burnableEntity])
		{
			[EntityUtil setEntityDisposed:burnableEntity sendNotification:FALSE];
			[[DisposableComponent getFrom:burnableEntity] setIsAboutToBeDeleted:TRUE];
		}

		if ([burnableEntity hasComponent:[CapturedComponent class]])
		{
			CapturedSystem *capturedSystem = (CapturedSystem *)[[_world systemManager] getSystem:[CapturedSystem class]];
			[capturedSystem saveContainedBees:burnableEntity];
		}

		if ([burnableEntity hasComponent:[PollenComponent class]])
		{
			PollenSystem *pollenSystem = (PollenSystem *) [[_world systemManager] getSystem:[PollenSystem class]];
			[pollenSystem collectPollen:burnableEntity];
		}

		if ([burnableEntity hasComponent:[RespawnComponent class]])
		{
			RespawnSystem *respawnSystem = (RespawnSystem *) [[_world systemManager] getSystem:[RespawnSystem class]];
			[respawnSystem addRespawnInfoForEntity:burnableEntity];
		}

		RenderSystem *renderSystem = (RenderSystem *) [[_world systemManager] getSystem:[RenderSystem class]];

		RenderComponent *renderComponent = [RenderComponent getFrom:burnableEntity];
		BOOL wasCallbackScheduled = FALSE;
		for (RenderSprite *renderSprite in [renderComponent renderSprites])
		{
			NSDictionary *burnSpriteDict = [[burnableComponent burnRenderSpritesByName] objectForKey:[renderSprite name]];

			// Create burn sprite
			NSString *burnSpriteSheetName = [burnSpriteDict objectForKey:@"spriteSheetName"];
			NSString *burnAnimationFile = [burnSpriteDict objectForKey:@"animationFile"];
			RenderSprite *burnRenderSprite = [renderSystem createRenderSpriteWithSpriteSheetName:burnSpriteSheetName animationFile:burnAnimationFile zOrder:[ZOrder Z_DEFAULT]];
			[burnRenderSprite setName:[renderSprite name]];
			[[burnRenderSprite sprite] setPosition:[[renderSprite sprite] position]];
			[[burnRenderSprite sprite] setRotation:[[renderSprite sprite] rotation]];
			[[burnRenderSprite sprite] setScaleX:[[renderSprite sprite] scaleX]];
			[[burnRenderSprite sprite] setAnchorPoint:[[renderSprite sprite] anchorPoint]];
			[burnRenderSprite addSpriteToSpriteSheet];

			NSString *burnAnimationName = [burnSpriteDict objectForKey:@"burnAnimation"];
			if (wasCallbackScheduled)
			{
				[burnRenderSprite playAnimationOnce:burnAnimationName andCallBlockAtEnd:^{
					[burnRenderSprite removeSpriteFromSpriteSheet];
				}];
			}
			else
			{
				[burnRenderSprite playAnimationOnce:burnAnimationName andCallBlockAtEnd:^{
					[burnRenderSprite removeSpriteFromSpriteSheet];
					[burnableEntity deleteEntity];
				}];
				wasCallbackScheduled = TRUE;
			}

			// Hide original sprite
			[renderSprite hide];
		}

		PhysicsComponent *physicsComponent = [PhysicsComponent getFrom:burnableEntity];
		cpBB boundingBox = [physicsComponent boundingBox];

		// Flames
		for (int i = 0; i < [burnableComponent numberOfFlames]; i++)
		{
			Entity *flameEntity = [EntityFactory createSimpleAnimatedEntity:_world animationFile:@"Burn-Parts-Animations.plist"];

			RenderComponent *flameRenderComponent = [RenderComponent getFrom:flameEntity];
			[[flameRenderComponent firstRenderSprite] playAnimationLoop:@"Burn-Flame"];

			CGPoint randomPosition = [EntityUtil getRandomPositionWithinShapes:[physicsComponent shapes] boundingBox:boundingBox];
			[EntityUtil setEntityPosition:flameEntity position:randomPosition];

			[EntityUtil fadeOutAndDeleteEntity:flameEntity duration:1.5f];
		}

		// Spawn pieces
		id delayAction = [CCDelayTime actionWithDuration:[burnableComponent pieceDelay]];
		id spawnPiecesAction = [CCCallBlock actionWithBlock:^(){
			if ([[burnableComponent pieceAnimationNames] count] > 0)
			{
				for (int i = 0; i < [[burnableComponent pieceAnimationNames] count]; i++)
				{
					NSString *pieceAnimationName = [[burnableComponent pieceAnimationNames] objectAtIndex:i];
					Entity *pieceEntity = [EntityFactory createShardPieceEntity:_world animationName:pieceAnimationName smallAnimationNames:[burnableComponent pieceSmallAnimationNames] spriteSheetName:[burnableComponent pieceSpriteSheetName] animationFile:[burnableComponent pieceAnimationFileName] shapeSize:CGSizeMake(10.0f, 10.0f)];

					PhysicsComponent *piecePhysicsComponent = [PhysicsComponent getFrom:pieceEntity];

					// Random position
					CGPoint randomPosition = [EntityUtil getRandomPositionWithinShapes:[physicsComponent shapes] boundingBox:boundingBox];
					[EntityUtil setEntityPosition:pieceEntity position:randomPosition];

					// Velocity
					if ([[burnableComponent pieceVelocities] count] > 0)
					{
						NSValue *velocityValue = [[burnableComponent pieceVelocities] objectAtIndex:i];
						CGPoint velocity = [velocityValue CGPointValue];
						[[piecePhysicsComponent body] setVel:velocity];
					}

					// Random rotation
					[EntityUtil setEntityRotation:pieceEntity rotation:rand() % 360];

					// Rotation velocity
					cpFloat randomAngularVelocity = -3.0f + ((rand() % 60) / 10.0f);
					[[piecePhysicsComponent body] setAngVel:randomAngularVelocity];

					if ([[burnableComponent pieceSmallAnimationNames] count] == 0)
					{
						// Fade out
						[EntityUtil fadeOutAndDeleteEntity:pieceEntity duration:1.5f];
					}
				}
			}
		}];
		[[[renderComponent firstRenderSprite] sprite] runAction:[CCSequence actionOne:delayAction two:spawnPiecesAction]];

		if ([burnableComponent burnSoundName] != nil)
		{
			[[SoundManager sharedManager] playSound:[burnableComponent burnSoundName]];
		}
	}

	return FALSE;
}

@end
