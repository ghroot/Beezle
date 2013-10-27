//
//  InAppPurchasesManager.m
//  Beezle
//
//  Created by Marcus Lagerstrom on 02/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "InAppPurchasesManager.h"
#import "PlayerInformation.h"
#import "InAppProductIds.h"
#import "Logger.h"

static const int NUMBER_OF_BURNEE_PER_PURCHASE = 15;
static const int NUMBER_OF_STINGEE_PER_PURCHASE = 15;
static const int NUMBER_OF_IRONBEE_PER_PURCHASE = 15;
static const int NUMBER_OF_GOGGLES_PER_PURCHASE = 15;

@interface InAppPurchasesManager()

-(void) completeTransaction:(SKPaymentTransaction *)transaction;
-(void) failedTransaction: (SKPaymentTransaction *)transaction;
-(void) restoreTransaction:(SKPaymentTransaction *)transaction;
-(void) provideContent:(NSString *)string quantity:(int)quantity;

@end

@implementation InAppPurchasesManager

@synthesize delegate = _delegate;

+(InAppPurchasesManager *) sharedManager
{
	static InAppPurchasesManager *manager = 0;
	if (!manager)
	{
		manager = [[self alloc] init];
	}
	return manager;
}

-(id) init
{
	if (self = [super init])
	{
		_productsByProductId = [NSMutableDictionary new];
		_priceStringsByProductId = [NSMutableDictionary new];
	}
	return self;
}

-(void) dealloc
{
	[_productsByProductId release];
	[_priceStringsByProductId release];

	[super dealloc];
}

-(void) initialise
{
	[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

-(BOOL) canMakePayments
{
	return [SKPaymentQueue canMakePayments];
}

-(void) updateProductInformation
{
	[_productsByProductId removeAllObjects];

	SKProductsRequest *request = [[[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObjects:BURNEE_PRODUCT_ID, STINGEE_PRODUCT_ID, IRONBEE_PRODUCT_ID, GOGGLES_PRODUCT_ID, nil]] autorelease];
	[request setDelegate:self];
	[request start];
}

-(void) productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
	for (SKProduct *product in [response products])
	{
		[_productsByProductId setObject:product forKey:[product productIdentifier]];

		NSNumberFormatter *numberFormatter = [[[NSNumberFormatter alloc] init] autorelease];
		[numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
		[numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
		[numberFormatter setLocale:[product priceLocale]];
		NSString *priceString = [numberFormatter stringFromNumber:[product price]];
		[_priceStringsByProductId setObject:priceString forKey:[product productIdentifier]];
	}
}

-(NSString *) priceStringForProduct:(NSString *)productId
{
	return [_priceStringsByProductId objectForKey:productId];
}

-(void) buy:(NSString *)productId
{
	if (![self canMakePayments] ||
			[_productsByProductId objectForKey:productId] == nil ||
			_isPurchaseInProgress)
	{
		[_delegate purchaseFailed:FALSE];
		return;
	}

	_isPurchaseInProgress = TRUE;

	SKProduct *product = [_productsByProductId objectForKey:productId];
	SKPayment *payment = [SKPayment paymentWithProduct:product];
	[[SKPaymentQueue defaultQueue] addPayment:payment];

#ifdef DEBUG
	[[Logger defaultLogger] log:[NSString stringWithFormat:@"Buying %@", productId]];
#endif
}

-(void) restorePurchases
{
	_isPurchaseInProgress = TRUE;

	[[SKPaymentQueue defaultQueue] restoreCompletedTransactions];

#ifdef DEBUG
	[[Logger defaultLogger] log:@"Restoring purchases"];
#endif
}

-(void) paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
	for (SKPaymentTransaction *transaction in transactions)
	{
		switch ([transaction transactionState])
		{
			case SKPaymentTransactionStatePurchased:
			{
				[self completeTransaction:transaction];
				break;
			}
			case SKPaymentTransactionStateFailed:
			{
				[self failedTransaction:transaction];
				break;
			}
			case SKPaymentTransactionStateRestored:
			{
				[self restoreTransaction:transaction];
				break;
			}
			default:
			{
				break;
			}
		}
	}
}

-(void) completeTransaction:(SKPaymentTransaction *)transaction
{
	[self provideContent:[[transaction payment] productIdentifier] quantity:[[transaction payment] quantity]];
	[_delegate purchaseWasSuccessful];
	[[SKPaymentQueue defaultQueue] finishTransaction:transaction];

	_isPurchaseInProgress = FALSE;

#ifdef DEBUG
	[[Logger defaultLogger] log:@"Purchase successful"];
#endif
}

-(void) failedTransaction: (SKPaymentTransaction *)transaction
{
	[_delegate purchaseFailed:([[transaction error] code] == SKErrorPaymentCancelled)];
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];

	_isPurchaseInProgress = FALSE;

#ifdef DEBUG
	[[Logger defaultLogger] log:@"Purchase failed"];
#endif
}

-(void) restoreTransaction:(SKPaymentTransaction *)transaction
{
	[self provideContent:[[[transaction originalTransaction] payment] productIdentifier] quantity:[[[transaction originalTransaction] payment] quantity]];
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];

	_isPurchaseInProgress = FALSE;
}

-(void) provideContent:(NSString *)string quantity:(int)quantity
{
	if ([string isEqualToString:BURNEE_PRODUCT_ID])
	{
		[[PlayerInformation sharedInformation] setNumberOfBurnee:[[PlayerInformation sharedInformation] numberOfBurnee] + quantity * NUMBER_OF_BURNEE_PER_PURCHASE];
	}
	else if ([string isEqualToString:STINGEE_PRODUCT_ID])
	{
		[[PlayerInformation sharedInformation] setNumberOfStingee:[[PlayerInformation sharedInformation] numberOfStingee] + quantity * NUMBER_OF_STINGEE_PER_PURCHASE];
	}
	else if ([string isEqualToString:IRONBEE_PRODUCT_ID])
	{
		[[PlayerInformation sharedInformation] setNumberOfIronBee:[[PlayerInformation sharedInformation] numberOfIronBee] + quantity * NUMBER_OF_IRONBEE_PER_PURCHASE];
	}
	else if ([string isEqualToString:GOGGLES_PRODUCT_ID])
	{
		[[PlayerInformation sharedInformation] setNumberOfGoggles:[[PlayerInformation sharedInformation] numberOfGoggles] + quantity * NUMBER_OF_GOGGLES_PER_PURCHASE];
	}
	[[PlayerInformation sharedInformation] save];
}

@end
