//
// Created by Marcus on 18/04/2013.
//

#import "InAppLayer.h"
#import "CCBReader.h"
#import "InAppPurchasesManager.h"
#import "PlayerInformation.h"
#import "SlingerComponent.h"
#import "BeeQueueRenderingSystem.h"
#import "InAppProductIds.h"
#import "TutorialStripDescription.h"
#import "TutorialOrganizer.h"
#import "TutorialStripMenuState.h"
#import "Game.h"
#import "NSObject+PWObject.h"
#import "SoundManager.h"
#import "RenderSystem.h"
#import "ZOrder.h"
#import "RenderSprite.h"
#import "TransformComponent.h"
#import "GameplayState.h"
#import "PausedMode.h"
#import "AimingMode.h"
#import "SessionTracker.h"

@interface InAppLayer()

-(void) buy:(NSString *)productId;
-(void) refresh;

@end

@implementation InAppLayer

-(id) initWithWorld:(World *)world game:(Game *)game gameplayState:(GameplayState *)gameplayState
{
	if (self = [super init])
	{
		_world = world;
		_game = game;
		_gameplayState = gameplayState;

		_interfaceNode = [[CCBReader nodeGraphFromFile:@"InApp.ccbi" owner:self] retain];
		[self addChild:_interfaceNode];

		_coverLayer = [[CCLayerColor layerWithColor:ccc4(0, 0, 0, 100)] retain];
		CCSprite *loadingSprite = [CCSprite spriteWithFile:@"Syst-Text-Loading.png"];
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		[loadingSprite setPosition:CGPointMake(winSize.width / 2, winSize.height / 2)];
		[_coverLayer addChild:loadingSprite];

		_isInView = TRUE;

		[[InAppPurchasesManager sharedManager] setDelegate:self];

		[self refresh];
	}
	return self;
}

-(void) dealloc
{
	[_interfaceNode release];
	[_coverLayer release];

	[super dealloc];
}


-(void) useBurnee
{
	if ([[PlayerInformation sharedInformation] numberOfBurnee] > 0)
	{
		TagManager *tagManager = (TagManager *)[_world getManager:[TagManager class]];
		Entity *slingerEntity = [tagManager getEntity:@"SLINGER"];
		SlingerComponent *slingerComponent = [SlingerComponent getFrom:slingerEntity];
		if ([[slingerComponent queuedBeeTypes] objectAtIndex:0] != [BeeType BURNEE])
		{
			[slingerComponent insertBeeTypeAtStart:[BeeType BURNEE]];

			BeeQueueRenderingSystem *beeQueueRenderingSystem = [[_world systemManager] getSystem:[BeeQueueRenderingSystem class]];
			[beeQueueRenderingSystem refreshSprites];
			[beeQueueRenderingSystem highlightBeeFirstInQueue];

			[[PlayerInformation sharedInformation] setNumberOfBurnee:[[PlayerInformation sharedInformation] numberOfBurnee] - 1];
			[[PlayerInformation sharedInformation] save];

			[self refresh];

			[_menu setEnabled:FALSE];

			[self performBlock:^{
				if (![[PlayerInformation sharedInformation] hasSeenTutorialId:@"STRIP-BURNEE"])
				{
					TutorialStripDescription *tutorialStripDescription = (TutorialStripDescription *) [[TutorialOrganizer sharedOrganizer] getTutorialDescription:@"STRIP-BURNEE"];
					TutorialStripMenuState *tutorialStripMenuState = [[[TutorialStripMenuState alloc] initWithFileName:[tutorialStripDescription fileName] buttonFileName:[tutorialStripDescription buttonFileName] block:^{
						[_game popState];
					}] autorelease];
					[_game pushState:tutorialStripMenuState];

					[[PlayerInformation sharedInformation] markTutorialIdAsSeenAndSave:[tutorialStripDescription id]];
				}
				[_menu setEnabled:TRUE];
			} afterDelay:0.8f];

			[[SessionTracker sharedTracker] trackInteraction:@"button" name:@"use burnee"];
		}
	}
	else
	{
		[[SessionTracker sharedTracker] trackInteraction:@"button" name:@"buy burnee"];

		[self buy:BURNEE_PRODUCT_ID];
	}
}

-(void) useStingee
{
	if ([[PlayerInformation sharedInformation] numberOfStingee] > 0)
	{
		TagManager *tagManager = (TagManager *)[_world getManager:[TagManager class]];
		Entity *slingerEntity = [tagManager getEntity:@"SLINGER"];
		SlingerComponent *slingerComponent = [SlingerComponent getFrom:slingerEntity];
		if ([[slingerComponent queuedBeeTypes] objectAtIndex:0] != [BeeType STINGEE])
		{
			[slingerComponent insertBeeTypeAtStart:[BeeType STINGEE]];

			BeeQueueRenderingSystem *beeQueueRenderingSystem = [[_world systemManager] getSystem:[BeeQueueRenderingSystem class]];
			[beeQueueRenderingSystem refreshSprites];
			[beeQueueRenderingSystem highlightBeeFirstInQueue];

			[[PlayerInformation sharedInformation] setNumberOfStingee:[[PlayerInformation sharedInformation] numberOfStingee] - 1];
			[[PlayerInformation sharedInformation] save];

			[self refresh];

			[_menu setEnabled:FALSE];

			[self performBlock:^{
				if (![[PlayerInformation sharedInformation] hasSeenTutorialId:@"STRIP-STINGEE"])
				{
					TutorialStripDescription *tutorialStripDescription = (TutorialStripDescription *) [[TutorialOrganizer sharedOrganizer] getTutorialDescription:@"STRIP-STINGEE"];
					TutorialStripMenuState *tutorialStripMenuState = [[[TutorialStripMenuState alloc] initWithFileName:[tutorialStripDescription fileName] buttonFileName:[tutorialStripDescription buttonFileName] block:^{
						[_game popState];
					}] autorelease];
					[_game pushState:tutorialStripMenuState];

					[[PlayerInformation sharedInformation] markTutorialIdAsSeenAndSave:[tutorialStripDescription id]];
				}
				[_menu setEnabled:TRUE];
			} afterDelay:0.8f];

			[[SessionTracker sharedTracker] trackInteraction:@"button" name:@"use stingee"];
		}
	}
	else
	{
		[[SessionTracker sharedTracker] trackInteraction:@"button" name:@"buy stingee"];

		[self buy:STINGEE_PRODUCT_ID];
	}
}

-(void) useIronBee
{
	if ([[PlayerInformation sharedInformation] numberOfIronBee] > 0)
	{
		TagManager *tagManager = (TagManager *)[_world getManager:[TagManager class]];
		Entity *slingerEntity = [tagManager getEntity:@"SLINGER"];
		SlingerComponent *slingerComponent = [SlingerComponent getFrom:slingerEntity];
		if ([[slingerComponent queuedBeeTypes] objectAtIndex:0] != [BeeType IRONBEE])
		{
			[slingerComponent insertBeeTypeAtStart:[BeeType IRONBEE]];

			BeeQueueRenderingSystem *beeQueueRenderingSystem = [[_world systemManager] getSystem:[BeeQueueRenderingSystem class]];
			[beeQueueRenderingSystem refreshSprites];
			[beeQueueRenderingSystem highlightBeeFirstInQueue];

			[[PlayerInformation sharedInformation] setNumberOfIronBee:[[PlayerInformation sharedInformation] numberOfIronBee] - 1];
			[[PlayerInformation sharedInformation] save];

			[self refresh];

			[_menu setEnabled:FALSE];

			[self performBlock:^{
				if (![[PlayerInformation sharedInformation] hasSeenTutorialId:@"STRIP-IRONBEE"])
				{
					TutorialStripDescription *tutorialStripDescription = (TutorialStripDescription *) [[TutorialOrganizer sharedOrganizer] getTutorialDescription:@"STRIP-IRONBEE"];
					TutorialStripMenuState *tutorialStripMenuState = [[[TutorialStripMenuState alloc] initWithFileName:[tutorialStripDescription fileName] buttonFileName:[tutorialStripDescription buttonFileName] block:^{
						[_game popState];
					}] autorelease];
					[_game pushState:tutorialStripMenuState];

					[[PlayerInformation sharedInformation] markTutorialIdAsSeenAndSave:[tutorialStripDescription id]];
				}
				[_menu setEnabled:TRUE];
			} afterDelay:0.8f];

			[[SessionTracker sharedTracker] trackInteraction:@"button" name:@"use ironbee"];
		}
	}
	else
	{
		[[SessionTracker sharedTracker] trackInteraction:@"button" name:@"buy ironbee"];

		[self buy:IRONBEE_PRODUCT_ID];
	}
}

-(void) useGoggles
{
	TagManager *tagManager = (TagManager *)[_world getManager:[TagManager class]];
	Entity *slingerEntity = [tagManager getEntity:@"SLINGER"];
	SlingerComponent *slingerComponent = [SlingerComponent getFrom:slingerEntity];
	if ([[PlayerInformation sharedInformation] numberOfGoggles] > 0)
	{
		if (![slingerComponent isGogglesActive])
		{
			[slingerComponent setIsGogglesActive:TRUE];

			TransformComponent *transformComponent = [TransformComponent getFrom:slingerEntity];
			SystemManager *systemManager = (SystemManager *) [_world getManager:[SystemManager class]];
			RenderSystem *renderSystem = (RenderSystem *) [systemManager getSystem:[RenderSystem class]];
			RenderSprite *highlightRenderSprite = [renderSystem createRenderSpriteWithSpriteSheetName:@"Shared" zOrder:[ZOrder Z_FRONT]];
			[[highlightRenderSprite sprite] setPosition:CGPointMake([transformComponent position].x + 24.0f, [transformComponent position].y - 15.0f)];
			[highlightRenderSprite addSpriteToSpriteSheet];
			[highlightRenderSprite playAnimationOnce:@"Slinger-Highlight" andCallBlockAtEnd:^{
				[highlightRenderSprite removeSpriteFromSpriteSheet];
			}];

			[[SoundManager sharedManager] playSound:@"SlingerInstall"];

			[[PlayerInformation sharedInformation] setNumberOfGoggles:[[PlayerInformation sharedInformation] numberOfGoggles] - 1];
			[[PlayerInformation sharedInformation] save];

			[self refresh];

			[_menu setEnabled:FALSE];

			[self performBlock:^{
				if (![[PlayerInformation sharedInformation] hasSeenTutorialId:@"STRIP-GOGGLES"])
				{
					TutorialStripDescription *tutorialStripDescription = (TutorialStripDescription *) [[TutorialOrganizer sharedOrganizer] getTutorialDescription:@"STRIP-GOGGLES"];
					TutorialStripMenuState *tutorialStripMenuState = [[[TutorialStripMenuState alloc] initWithFileName:[tutorialStripDescription fileName] buttonFileName:[tutorialStripDescription buttonFileName] block:^{
						[_game popState];
					}] autorelease];
					[_game pushState:tutorialStripMenuState];

					[[PlayerInformation sharedInformation] markTutorialIdAsSeenAndSave:[tutorialStripDescription id]];
				}
				[_menu setEnabled:TRUE];
			} afterDelay:0.8f];

			[[SessionTracker sharedTracker] trackInteraction:@"button" name:@"use goggles"];
		}
	}
	else
	{
		[[SessionTracker sharedTracker] trackInteraction:@"button" name:@"buy goggles"];

		[self buy:GOGGLES_PRODUCT_ID];
	}
}

-(void) refresh
{
	int numberOfIronBee = [[PlayerInformation sharedInformation] numberOfIronBee];
	[_ironBeeQuantityLabel setVisible:numberOfIronBee > 0];
	[_ironBeeQuantityLabel setString:[NSString stringWithFormat:@"%d", numberOfIronBee]];
	[_buyIronBeeTagSprite setVisible:numberOfIronBee == 0];

	int numberOfStingee = [[PlayerInformation sharedInformation] numberOfStingee];
	[_stingeeQuantityLabel setVisible:numberOfStingee > 0];
	[_stingeeQuantityLabel setString:[NSString stringWithFormat:@"%d", numberOfStingee]];
	[_buyStingeeTagSprite setVisible:numberOfStingee == 0];

	int numberOfBurnee = [[PlayerInformation sharedInformation] numberOfBurnee];
	[_burneeQuantityLabel setVisible:numberOfBurnee > 0];
	[_burneeQuantityLabel setString:[NSString stringWithFormat:@"%d", numberOfBurnee]];
	[_buyBurneeTagSprite setVisible:numberOfBurnee == 0];

	int numberOfGoggles = [[PlayerInformation sharedInformation] numberOfGoggles];
	[_gogglesQuantityLabel setVisible:numberOfGoggles > 0];
	[_gogglesQuantityLabel setString:[NSString stringWithFormat:@"%d", numberOfGoggles]];
	[_buyGogglesTagSprite setVisible:numberOfGoggles == 0];
}

-(void) buy:(NSString *)productId
{
	// Show loading
	[self addChild:_coverLayer];
	[_menu setEnabled:FALSE];
	[_gameplayState enterMode:[_gameplayState getMode:[PausedMode class]]];

	[[InAppPurchasesManager sharedManager] buy:productId];
}

-(void) purchaseWasSuccessful
{
	// Hide loading
	[self removeChild:_coverLayer];
	[_menu setEnabled:TRUE];
	[_gameplayState enterMode:[_gameplayState getMode:[AimingMode class]]];

	[self refresh];

	[[SessionTracker sharedTracker] trackInteraction:@"button" name:@"purchase successful"];
}

-(void) purchaseFailed:(BOOL)canceled
{
	// Hide loading
	[self removeChild:_coverLayer];
	[_menu setEnabled:TRUE];
	[_gameplayState enterMode:[_gameplayState getMode:[AimingMode class]]];

	[[SessionTracker sharedTracker] trackInteraction:@"button" name:@"purchase failed"];
}

-(void) ensureInView:(BOOL)shouldBeInView
{
	if (shouldBeInView)
	{
		if (!_isInView)
		{
			[_interfaceNode stopAllActions];
			[_interfaceNode runAction:[CCMoveTo actionWithDuration:0.3f position:CGPointMake(2.0f, [_interfaceNode position].y)]];

			_isInView = TRUE;
		}
	}
	else
	{
		if (_isInView)
		{
			[_interfaceNode stopAllActions];
			[_interfaceNode runAction:[CCMoveTo actionWithDuration:0.3f position:CGPointMake(-80.0f, [_interfaceNode position].y)]];

			_isInView = FALSE;
		}
	}
}

@end
