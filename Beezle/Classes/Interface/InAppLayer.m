//
// Created by Marcus on 18/04/2013.
//

#import "InAppLayer.h"
#import "CCBReader.h"
#import "InAppPurchasesManager.h"
#import "PlayerInformation.h"
#import "SlingerComponent.h"
#import "BeeQueueRenderingSystem.h"

@interface InAppLayer()

-(void) updateBuyTagVisibility;

@end

@implementation InAppLayer

-(id) initWithWorld:(World *)world
{
	if (self = [super init])
	{
		_world = world;

		[self addChild:[CCBReader nodeGraphFromFile:@"InApp.ccbi" owner:self]];

		[[InAppPurchasesManager sharedManager] setDelegate:self];

		[self updateBuyTagVisibility];
	}
	return self;
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

			[self updateBuyTagVisibility];
		}
	}
	else
	{
		[[InAppPurchasesManager sharedManager] buy:BURNEE_PRODUCT_ID];
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

			[[PlayerInformation sharedInformation] setNumberOfGoggles:[[PlayerInformation sharedInformation] numberOfGoggles] - 1];
			[[PlayerInformation sharedInformation] save];

			[self updateBuyTagVisibility];
		}
	}
	else
	{
		[[InAppPurchasesManager sharedManager] buy:GOGGLES_PRODUCT_ID];
	}
}

-(void) updateBuyTagVisibility
{
	[_buyBurneeTagSprite setVisible:[[PlayerInformation sharedInformation] numberOfBurnee] == 0];
	[_buyGogglesTagSprite setVisible:[[PlayerInformation sharedInformation] numberOfGoggles] == 0];
}

-(void) purchaseWasSuccessful
{
	[self updateBuyTagVisibility];
}

-(void) purchaseFailed:(BOOL)canceled
{
}

@end
