//
// Created by Marcus on 24/02/2013.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import <iAd/iAd.h>
#import "cocos2d.h"

@interface AdManager : NSObject <ADBannerViewDelegate>
{
	UINavigationController *_navigationController;
	ADBannerView *_banner;
}

+(AdManager *) sharedManager;

-(void) initialise:(UINavigationController *) navigationController;
-(void) showBanner;
-(void) hideBanner;

@end
