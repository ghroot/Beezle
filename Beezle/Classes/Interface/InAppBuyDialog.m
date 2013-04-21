//
// Created by Marcus on 19/04/2013.
//

#import "InAppBuyDialog.h"
#import "CCBReader.h"
#import "InAppPurchasesManager.h"

@implementation InAppBuyDialog

-(id) initWithInterfaceFile:(NSString *)filePath andProductId:(NSString *)productId
{
	if (self = [super initWithNode:[CCBReader nodeGraphFromFile:filePath owner:self] coverOpacity:128])
	{
		_productId = [productId copy];

		[_priceLabel setString:[[InAppPurchasesManager sharedManager] priceStringForProduct:_productId]];
	}
	return self;
}

-(void) dealloc
{
	[_productId release];

	[super dealloc];
}

-(void) buy
{
	[[InAppPurchasesManager sharedManager] buy:_productId];
	[self close];
}

-(void) cancel
{
	[self close];
}

@end
