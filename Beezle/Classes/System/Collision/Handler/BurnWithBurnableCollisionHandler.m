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

@interface BurnWithBurnableCollisionHandler()

-(void) applyDefaultBurnBehaviour:(Entity *)entity;
-(void) replaceWithBurnSprites:(Entity *)entity;
-(void) spawnBurnPieces:(Entity *)entity;

@end

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

	[EntityUtil disablePhysics:burnableEntity];

	if ([burnableComponent useDefaultBurnBehaviour])
	{
		[self applyDefaultBurnBehaviour:burnableEntity];
	}
	else if ([[burnableComponent burnRenderSpritesByName] count] > 0)
	{
		[self replaceWithBurnSprites:burnableEntity];
	}

	if ([[burnableComponent pieceAnimationNames] count] > 0)
	{
		[self spawnBurnPieces:burnableEntity];
	}

	if ([burnableComponent burnSoundName] != nil)
	{
		[[SoundManager sharedManager] playSound:[burnableComponent burnSoundName]];
	}

	return FALSE;
}

-(void) applyDefaultBurnBehaviour:(Entity *)entity
{
	RenderComponent *renderComponent = [RenderComponent getFrom:entity];
	PhysicsComponent *physicsComponent = [PhysicsComponent getFrom:entity];
	cpBB boundingBox = [physicsComponent boundingBox];

	// Fire
	NSArray *fireAnimationNames = [NSArray arrayWithObjects:@"Burn-Fire-Small", @"Burn-Fire-Small", @"Burn-Fire-Small",
															@"Burn-Fire-Medium", @"Burn-Fire-Medium", @"Burn-Fire-Medium", @"Burn-Fire-Large", nil];
	for (int i = 0; i < [fireAnimationNames count]; i++)
	{
		Entity *fireEntity = [EntityFactory createSimpleAnimatedEntity:_world animationFile:@"Burn-Parts-Animations.plist"];

		RenderComponent *fireRenderComponent = [RenderComponent getFrom:fireEntity];
		NSString *fireAnimationName = [fireAnimationNames objectAtIndex:i];
		[[fireRenderComponent firstRenderSprite] playAnimationLoop:fireAnimationName];

		CGPoint randomPosition = [EntityUtil getRandomPositionWithinShapes:[physicsComponent shapes] boundingBox:boundingBox];
		[EntityUtil setEntityPosition:fireEntity position:randomPosition];

		[EntityUtil fadeOutAndDeleteEntity:fireEntity duration:1.5f];
	}

	// Smoke
	for (int i = 0; i < 3; i++)
	{
		Entity *smokeEntity = [EntityFactory createSimpleAnimatedEntity:_world animationFile:@"Burn-Parts-Animations.plist"];

		RenderComponent *smokeRenderComponent = [RenderComponent getFrom:smokeEntity];
		[[smokeRenderComponent firstRenderSprite] playAnimationLoop:@"Burn-Smoke"];

		CGPoint randomPosition = [EntityUtil getRandomPositionWithinShapes:[physicsComponent shapes] boundingBox:boundingBox];
		[EntityUtil setEntityPosition:smokeEntity position:randomPosition];

		[EntityUtil fadeOutAndDeleteEntity:smokeEntity duration:1.5f];
	}

	// Tint and fade out
	id waitForTintAction = [CCDelayTime actionWithDuration:0.2f];
	id tintAndFadeOutAction = [CCCallBlock actionWithBlock:^(){
		// Tint black
		for (RenderSprite *renderSprite in [renderComponent renderSprites])
		{
			[renderSprite stopAnimation];
			[[renderSprite sprite] setColor:ccc3(0, 0, 0)];
		}

		// Fade out
		for (RenderSprite *renderSprite in [renderComponent renderSprites])
		{
			id waitForFadeOutAction = [CCDelayTime actionWithDuration:0.6f];
			id fadeOutAction = [CCFadeOut actionWithDuration:0.3f];
			[[renderSprite sprite] runAction:[CCSequence actionOne:waitForFadeOutAction two:fadeOutAction]];
		}
	}];
	[[[renderComponent firstRenderSprite] sprite] runAction:[CCSequence actionOne:waitForTintAction two:tintAndFadeOutAction]];

	// Coal pieces
	id waitForCoalPiecesAction = [CCDelayTime actionWithDuration:0.5f];
	id spawnCoalPiecesAction = [CCCallBlock actionWithBlock:^(){
		for (int i = 0; i < 5; i++)
		{
			NSString *coalPieceAnimationName = [NSString stringWithFormat:@"Coal-Piece-%d", (i + 1)];
			Entity *coalPieceEntity = [EntityFactory createShardPieceEntity:_world animationName:coalPieceAnimationName smallAnimationNames:nil spriteSheetName:@"Shared" animationFile:@"Burn-Parts-Animations.plist" shapeSize:CGSizeMake(10.0f, 10.0f)];

			// Random position
			CGPoint randomPosition = [EntityUtil getRandomPositionWithinShapes:[physicsComponent shapes] boundingBox:boundingBox];
			[EntityUtil setEntityPosition:coalPieceEntity position:randomPosition];

			// Random rotation
			[EntityUtil setEntityRotation:coalPieceEntity rotation:rand() % 360];

			// Fade out
			[EntityUtil fadeOutAndDeleteEntity:coalPieceEntity duration:1.5f];
		}
	}];
	[[[renderComponent firstRenderSprite] sprite] runAction:[CCSequence actionOne:waitForCoalPiecesAction two:spawnCoalPiecesAction]];
}

-(void) replaceWithBurnSprites:(Entity *)entity
{
	BurnableComponent *burnableComponent = [BurnableComponent getFrom:entity];
	RenderComponent *renderComponent = [RenderComponent getFrom:entity];
	RenderSystem *renderSystem = (RenderSystem *) [[_world systemManager] getSystem:[RenderSystem class]];

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
				[entity deleteEntity];
			}];
			wasCallbackScheduled = TRUE;
		}

		// Hide original sprite
		[renderSprite hide];
	}
}

-(void) spawnBurnPieces:(Entity *)entity
{
	BurnableComponent *burnableComponent = [BurnableComponent getFrom:entity];
	RenderComponent *renderComponent = [RenderComponent getFrom:entity];
	PhysicsComponent *physicsComponent = [PhysicsComponent getFrom:entity];
	cpBB boundingBox = [physicsComponent boundingBox];

	id delayAction = [CCDelayTime actionWithDuration:[burnableComponent pieceDelay]];
	id spawnPiecesAction = [CCCallBlock actionWithBlock:^(){
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
	}];
	[[[renderComponent firstRenderSprite] sprite] runAction:[CCSequence actionOne:delayAction two:spawnPiecesAction]];
}

@end
