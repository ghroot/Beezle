//
// Created by Marcus on 19/04/2013.
//

#import "Dialog.h"

@interface InAppBuyDialog : Dialog
{
	NSString *_productId;

	CCLabelTTF *_priceLabel;
}

-(id) initWithInterfaceFile:(NSString *)filePath andProductId:(NSString *)productId;

-(void) buy;
-(void) cancel;

@end
