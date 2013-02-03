//
//  InAppPurchasesManager.h
//  Beezle
//
//  Created by Marcus Lagerstrom on 02/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <StoreKit/StoreKit.h>

@interface InAppPurchasesManager : NSObject <SKPaymentTransactionObserver, SKProductsRequestDelegate, UIAlertViewDelegate>
{
	SKProduct *_upgradeToFullVersionProduct;
}

+(InAppPurchasesManager *) sharedManager;

-(void) initialise;
-(BOOL) canMakePayments;
-(void) upgradeToFullVersion;
-(void) restorePurchases;

@end
