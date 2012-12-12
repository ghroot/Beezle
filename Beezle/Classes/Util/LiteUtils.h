//
// Created by Marcus on 26/11/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//

@interface LiteUtils : NSObject <UIAlertViewDelegate>

+(LiteUtils *) sharedUtils;

-(void) gotoAppStoreForFullVersion;
-(void) showBuyFullVersionAlert;

@end
