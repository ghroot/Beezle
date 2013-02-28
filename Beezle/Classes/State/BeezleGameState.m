//
// Created by Marcus on 28/02/2013.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "BeezleGameState.h"
#import "AdManager.h"

@implementation BeezleGameState

-(void) enter
{
	[super enter];

#ifdef LITE_VERSION
	if (_shouldShowAd)
	{
		[[AdManager sharedManager] ensureBanner];
	}
	else
	{
		[[AdManager sharedManager] ensureNoBanner];
	}
#endif
}

@end
