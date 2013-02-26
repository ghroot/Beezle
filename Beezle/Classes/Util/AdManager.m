//
// Created by Marcus on 24/02/2013.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "AdManager.h"
#import "Logger.h"
#import "SoundManager.h"
#import "PlayerInformation.h"

@implementation AdManager

+(AdManager *) sharedManager
{
	static AdManager *manager = 0;
	if (!manager)
	{
		manager = [[self alloc] init];
	}
	return manager;
}

-(void) initialise:(UINavigationController *) navigationController
{
	_navigationController = navigationController;
}

-(void) dealloc
{
	[_banner release];

	[super dealloc];
}


-(void) showBanner
{
	[self hideBanner];

	_banner = [[ADBannerView alloc] initWithFrame:CGRectZero];
	[_banner setDelegate:self];
	[_banner setRequiredContentSizeIdentifiers:[NSSet setWithObject:ADBannerContentSizeIdentifierLandscape]];
	[_banner setCurrentContentSizeIdentifier:ADBannerContentSizeIdentifierLandscape];
	[_banner setCenter:CGPointMake([[CCDirector sharedDirector] winSize].width / 2, 15.0f)];
	[_banner setHidden:TRUE];
	[[_navigationController view] addSubview:_banner];
}

-(void) hideBanner
{
	if (_banner != nil)
	{
		[_banner setDelegate:nil];
		[_banner removeFromSuperview];
		[_banner release];
		_banner = nil;
	}
}

-(void) bannerViewDidLoadAd:(ADBannerView *)banner
{
	[banner setHidden:FALSE];

#ifdef DEBUG
	[[Logger defaultLogger] log:@"Showing iAd"];
#endif
}

-(void) bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
	[banner setHidden:TRUE];

#ifdef DEBUG
	[[Logger defaultLogger] log:[NSString stringWithFormat:@"Error showing iAd: %@", [error localizedDescription]]];
#endif
}

-(void) bannerViewActionDidFinish:(ADBannerView *)banner
{
	[banner setHidden:FALSE];
	[[CCDirector sharedDirector] stopAnimation];
	[[CCDirector sharedDirector] resume];
	[[CCDirector sharedDirector] startAnimation];
	if (![[PlayerInformation sharedInformation] isSoundMuted])
	{
		[[SoundManager sharedManager] unMute];
	}
}

-(BOOL) bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
	[banner setHidden:TRUE];
	[[CCDirector sharedDirector] stopAnimation];
	[[CCDirector sharedDirector] pause];
	[[SoundManager sharedManager] mute];
	return !willLeave;
}

@end
