//
//  InAppPurchasesManager.h
//  Beezle
//
//  Created by Marcus Lagerstrom on 02/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <StoreKit/StoreKit.h>

static NSString *BURNEE_PRODUCT_ID = @"com.stinglab.inapp.burnee";
static NSString *GOGGLES_PRODUCT_ID = @"com.stinglab.inapp.goggles";

@protocol InAppPurchasesDelegate <NSObject>

-(void) purchaseWasSuccessful;
-(void) purchaseFailed:(BOOL)canceled;

@end

@interface InAppPurchasesManager : NSObject <SKPaymentTransactionObserver, SKProductsRequestDelegate>
{
	NSMutableDictionary *_products;
	id<InAppPurchasesDelegate> _delegate;
	BOOL _isPurchaseInProgress;
}

@property (nonatomic, assign) id<InAppPurchasesDelegate> delegate;

+(InAppPurchasesManager *) sharedManager;

-(void) initialise;
-(BOOL) canMakePayments;
-(void) updateProductInformation;
-(void) buy:(NSString *)productId;
-(void) restorePurchases;

@end
