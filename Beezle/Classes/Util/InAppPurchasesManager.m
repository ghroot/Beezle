//
//  InAppPurchasesManager.m
//  Beezle
//
//  Created by Marcus Lagerstrom on 02/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "InAppPurchasesManager.h"
#import "PlayerInformation.h"

static NSString *FULL_VERSION_UPGRADE_PRODUCT_ID = @"com.stinglab.inapp.fullupgrade";

@interface InAppPurchasesManager()

-(void) completeTransaction:(SKPaymentTransaction *)transaction;
-(void) failedTransaction: (SKPaymentTransaction *)transaction;
-(void) restoreTransaction:(SKPaymentTransaction *)transaction;
-(void) provideContent:(NSString *)string;

@end

@implementation InAppPurchasesManager

+(InAppPurchasesManager *) sharedManager
{
	static InAppPurchasesManager *manager = 0;
	if (!manager)
	{
		manager = [[self alloc] init];
	}
	return manager;
}

-(void) dealloc
{
	[_upgradeToFullVersionProduct release];

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

-(void) upgradeToFullVersion
{
	if (![self canMakePayments])
	{
		return;
	}

	SKProductsRequest *request = [[[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:FULL_VERSION_UPGRADE_PRODUCT_ID]] autorelease];
	[request setDelegate:self];
	[request start];
}

-(void) productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
	for (SKProduct *product in [response products])
	{
		if ([[product productIdentifier] isEqualToString:FULL_VERSION_UPGRADE_PRODUCT_ID])
		{
			[_upgradeToFullVersionProduct release];
			_upgradeToFullVersionProduct = [product retain];

			NSNumberFormatter *numberFormatter = [[[NSNumberFormatter alloc] init] autorelease];
			[numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
			[numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
			[numberFormatter setLocale:[product priceLocale]];
			NSString *priceString = [numberFormatter stringFromNumber:[product price]];

			UIAlertView *dialog = [[UIAlertView alloc] init];
			[dialog setDelegate:self];
			[dialog setTitle:@"Full version"];
			[dialog setMessage:[NSString stringWithFormat:@"Would you like to upgrade to the full version for %@?", priceString]];
			[dialog addButtonWithTitle:@"Yes"];
			[dialog addButtonWithTitle:@"No"];
			[dialog show];
			[dialog release];

			break;
		}
	}
}

-(void) alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0)
	{
		SKPayment *payment = [SKPayment paymentWithProduct:_upgradeToFullVersionProduct];
		[[SKPaymentQueue defaultQueue] addPayment:payment];
	}
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
	[self provideContent:[[transaction payment] productIdentifier]];
	[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

-(void) failedTransaction: (SKPaymentTransaction *)transaction
{
	if ([[transaction error] code] != SKErrorPaymentCancelled)
	{
		// Optionally, display an error here.
	}
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

-(void) restoreTransaction:(SKPaymentTransaction *)transaction
{
	[self provideContent:[[[transaction originalTransaction] payment] productIdentifier]];
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

-(void) provideContent:(NSString *)string
{
	if ([string isEqualToString:FULL_VERSION_UPGRADE_PRODUCT_ID])
	{
		[[PlayerInformation sharedInformation] markAsUpgradedToFullVersion];
	}
}

@end
