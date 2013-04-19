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

@interface InAppLayer()

-(void) refresh;

@end

@implementation InAppLayer

-(id) initWithWorld:(World *)world
{
	if (self = [super init])
	{
		_world = world;

		_interfaceNode = [[CCBReader nodeGraphFromFile:@"InApp.ccbi" owner:self] retain];
		[self addChild:_interfaceNode];

		_isInView = TRUE;

		[[InAppPurchasesManager sharedManager] setDelegate:self];

		[self refresh];
	}
	return self;
}

-(void) dealloc
{
	[_interfaceNode release];

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

			[self refresh];
		}
	}
	else
	{
		[[InAppPurchasesManager sharedManager] buy:GOGGLES_PRODUCT_ID];
	}
}

-(void) refresh
{
	int numberOfBurnee = [[PlayerInformation sharedInformation] numberOfBurnee];
	[_burneeQuantityBoxSprite setVisible:numberOfBurnee > 0];
	[_burneeQuantityLabel setVisible:numberOfBurnee > 0];
	[_burneeQuantityLabel setString:[NSString stringWithFormat:@"%d", numberOfBurnee]];
	[_buyBurneeTagSprite setVisible:numberOfBurnee == 0];

	int numberOfGoggles = [[PlayerInformation sharedInformation] numberOfGoggles];
	[_gogglesQuantityBoxSprite setVisible:numberOfGoggles > 0];
	[_gogglesQuantityLabel setVisible:numberOfGoggles > 0];
	[_gogglesQuantityLabel setString:[NSString stringWithFormat:@"%d", numberOfGoggles]];
	[_buyGogglesTagSprite setVisible:numberOfGoggles == 0];
}

-(void) purchaseWasSuccessful
{
	[self refresh];
}

-(void) purchaseFailed:(BOOL)canceled
{
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
