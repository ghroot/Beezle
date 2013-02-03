//
//  InAppPurchasesManager.h
//  Beezle
//
//  Created by Marcus Lagerstrom on 02/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <StoreKit/StoreKit.h>

@protocol InAppPurchasesDelegate <NSObject>

-(void) didRecieveUpgradeProductWithName:(NSString *)name andPrice:(NSString *)price;
-(void) failedToGetProductInformation;
-(void) upgradeWasSuccessful;
-(void) upgradeFailed:(BOOL)canceled;

@end

@interface InAppPurchasesManager : NSObject <SKPaymentTransactionObserver, SKProductsRequestDelegate>
{
	SKProduct *_upgradeToFullVersionProduct;
	id<InAppPurchasesDelegate> _delegate;
}

@property (nonatomic, assign) id<InAppPurchasesDelegate> delegate;

+(InAppPurchasesManager *) sharedManager;

-(void) initialise;
-(BOOL) canMakePayments;
-(void) updateProductInformation;
-(void) upgradeToFullVersion;
-(void) restorePurchases;

@end
