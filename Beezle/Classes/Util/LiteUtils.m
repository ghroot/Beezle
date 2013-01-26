//
// Created by Marcus on 26/11/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "LiteUtils.h"
#import "ApplicationIds.h"

@interface LiteUtils()

-(void) alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@implementation LiteUtils

+(LiteUtils *) sharedUtils
{
	static LiteUtils *utils = 0;
	if (!utils)
	{
		utils = [[self alloc] init];
	}
	return utils;
}

-(void) gotoAppStoreForFullVersion
{
	NSString *url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%d", APPLE_APPLICATION_FULL_ID];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

-(void) showBuyFullVersionAlert
{
	UIAlertView *dialog = [[UIAlertView alloc] init];
	[dialog setDelegate:self];
	[dialog setTitle:@"Full version"];
	[dialog setMessage:@"Buy the full version to access all 160+ levels!"];
	[dialog addButtonWithTitle:@"App Store"];
	[dialog addButtonWithTitle:@"No thanks"];
	[dialog show];
	[dialog release];
}

-(void) alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0)
	{
		[self gotoAppStoreForFullVersion];
	}
}

@end
