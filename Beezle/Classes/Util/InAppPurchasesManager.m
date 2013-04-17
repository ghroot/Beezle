//
//  InAppPurchasesManager.m
//  Beezle
//
//  Created by Marcus Lagerstrom on 02/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "InAppPurchasesManager.h"
#import "PlayerInformation.h"

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
		_products = [NSMutableDictionary new];
	}
	return self;
}

-(void) dealloc
{
	[_products release];

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
	[_products removeAllObjects];

	SKProductsRequest *request = [[[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObjects:BURNEE_PRODUCT_ID, GOGGLES_PRODUCT_ID, nil]] autorelease];
	[request setDelegate:self];
	[request start];
}

-(void) productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
	for (SKProduct *product in [response products])
	{
		[_products setObject:product forKey:[product productIdentifier]];
	}

//		NSNumberFormatter *numberFormatter = [[[NSNumberFormatter alloc] init] autorelease];
//		[numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
//		[numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
//		[numberFormatter setLocale:[_upgradeToFullVersionProduct priceLocale]];
//		NSString *priceString = [numberFormatter stringFromNumber:[_upgradeToFullVersionProduct price]];
//
//		[_delegate didRecieveUpgradeProductWithName:[_upgradeToFullVersionProduct localizedTitle] andPrice:priceString];
}

-(void) buy:(NSString *)productId
{
	if (![self canMakePayments] ||
			[_products objectForKey:productId] == nil)
	{
		[_delegate puchaseFailed:FALSE];
		return;
	}

	SKProduct *product = [_products objectForKey:productId];
	SKPayment *payment = [SKPayment paymentWithProduct:product];
	[[SKPaymentQueue defaultQueue] addPayment:payment];
}

-(void) restorePurchases
{
	[[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
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
	[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

-(void) failedTransaction: (SKPaymentTransaction *)transaction
{
	[_delegate puchaseFailed:([[transaction error] code] == SKErrorPaymentCancelled)];
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

-(void) restoreTransaction:(SKPaymentTransaction *)transaction
{
	[self provideContent:[[[transaction originalTransaction] payment] productIdentifier] quantity:[[[transaction originalTransaction] payment] quantity]];
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

-(void) provideContent:(NSString *)string quantity:(int)quantity
{
	if ([string isEqualToString:BURNEE_PRODUCT_ID])
	{
		[[PlayerInformation sharedInformation] setNumberOfBurnee:[[PlayerInformation sharedInformation] numberOfBurnee] + quantity];
	}
	else if ([string isEqualToString:GOGGLES_PRODUCT_ID])
	{
		[[PlayerInformation sharedInformation] setNumberOfGoggles:[[PlayerInformation sharedInformation] numberOfGoggles] + quantity];
	}
	[[PlayerInformation sharedInformation] save];
}

@end
