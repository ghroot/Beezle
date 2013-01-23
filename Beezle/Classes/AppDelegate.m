//
//  AppDelegate.m
//  Beezle
//
//  Created by Me on 31/10/2011.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "AppDelegate.h"
#import "EmailInfo.h"
#import "Game.h"
#import "SessionTracker.h"
#import "SoundManager.h"
#import "MemoryManager.h"
#import "PlayState.h"
#import "iRate.h"
#import "PlayerInformation.h"
#import "AnimationSoundMediator.h"
#import "GameCenterManager.h"
#import "BeezleNavigationViewController.h"
#import "FacebookManager.h"
#import "ApplicationIds.h"

@implementation AppDelegate

+(void) initialize
{
	[super initialize];

	// iRate
#ifdef LITE_VERSION
	[[iRate sharedInstance] setAppStoreID:APPLE_APPLICATION_FREE_ID];
#else
	[[iRate sharedInstance] setAppStoreID:APPLE_APPLICATION_FULL_ID];
#endif
	[[iRate sharedInstance] setRemindPeriod:3.0f];
#ifdef DEBUG
	[[iRate sharedInstance] setVerboseLogging:TRUE];
#endif
}

-(BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// Create the main window
	_window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	// Create an CCGLView with a RGB565 color buffer, and a depth buffer of 0-bits
	CCGLView *glView = [CCGLView viewWithFrame:[_window bounds]
									pixelFormat:kEAGLColorFormatRGB565	//kEAGLColorFormatRGBA8
									depthFormat:0	//GL_DEPTH_COMPONENT24_OES
									preserveBackbuffer:NO
									sharegroup:nil
									multiSampling:NO
									numberOfSamples:0];

	_director = (CCDirectorIOS *)[CCDirector sharedDirector];
	[_director setWantsFullScreenLayout:TRUE];
	
	// Attach the openglView to the director
	[_director setView:glView];
	
	// Settings
	[_director setAnimationInterval:(1.0f / 60.0f)];
	[_director setProjection:kCCDirectorProjection2D];
	[_director setDepthTest:FALSE];
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
	
	// For rotation and other messages
	[_director setDelegate:self];
	
	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	[_director enableRetinaDisplay:TRUE];
	
	// Create a Navigation Controller with the Director
	_navigationController = [[BeezleNavigationViewController alloc] initWithRootViewController:_director];
	[_navigationController setNavigationBarHidden:TRUE];
	
	// Set the Navigation Controller as the root view controller
	if ([[[UIDevice currentDevice] systemVersion] compare:@"6.0" options:NSNumericSearch] != NSOrderedAscending)
	{
		[_window addSubview:_navigationController.view];
		[_window setRootViewController:_navigationController];
	}
	else
	{
		[_window addSubview:_navigationController.view];
	}
	
	// Show
	[_window makeKeyAndVisible];

	return TRUE;
}

-(void) dealloc
{
	[_window release];
	[_navigationController release];
	
	[_game release];
	
	[super dealloc];
}

-(void) directorDidReshapeProjection:(CCDirector*)director
{
	if ([director runningScene] == nil)
	{
		// Player information
		[[PlayerInformation sharedInformation] initialise];

		// Animation sound trigger
		[[AnimationSoundMediator sharedMediator] initialise];

#ifndef LITE_VERSION
		if ([[PlayerInformation sharedInformation] autoAuthenticateGameCenter])
		{
			// Game center
			[[GameCenterManager sharedManager] authenticate];
		}

		if ([[PlayerInformation sharedInformation] autoLoginToFacebook])
		{
			// Facebook
			[[FacebookManager sharedManager] login];
		}
#endif

		// Tracking
		[[SessionTracker sharedTracker] start];

		// Setup sound
		if ([[PlayerInformation sharedInformation] isSoundMuted])
		{
			[[SoundManager sharedManager] mute];
		}
		else
		{
			[[SoundManager sharedManager] unMute];
		}
		[[SoundManager sharedManager] setup];

		// Show first screen
		_game = [[Game alloc] init];
		[_game startWithState:[PlayState state]];
	}
}

-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight)
	{
		return TRUE;
	}
	else
	{
		return FALSE;
	}
}

-(NSUInteger) application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
	return UIInterfaceOrientationMaskAllButUpsideDown;
}

-(void) applicationWillResignActive:(UIApplication *)application
{
	if ([_navigationController visibleViewController] == _director)
	{
		[_director pause];
	}
}

-(void) applicationDidBecomeActive:(UIApplication *)application
{
	if ([_navigationController visibleViewController] == _director)
	{
		[_director resume];
		[_director setNextDeltaTimeZero:TRUE];
	}
}

-(void) applicationDidEnterBackground:(UIApplication *)application
{
	if ([_navigationController visibleViewController] == _director)
	{
		[_director stopAnimation];

		[[MemoryManager sharedManager] purgeCachedData];
	}
}

-(void) applicationWillEnterForeground:(UIApplication *)application
{
	if ([_navigationController visibleViewController] == _director)
	{
		[_director startAnimation];
	}
}

-(void) applicationWillTerminate:(UIApplication *)application
{
	[[FacebookManager sharedManager] closeSession];

	CC_DIRECTOR_END();
}

-(void) applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[[MemoryManager sharedManager] purgeCachedData];
}

-(void) applicationSignificantTimeChange:(UIApplication *)application
{
	[_director setNextDeltaTimeZero:TRUE];
}

-(BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
	[[FacebookManager sharedManager] handleOpenURL:url];

	return YES;
}

// iOS 4.3 compatibility
-(BOOL) application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
	[[FacebookManager sharedManager] handleOpenURL:url];

	return TRUE;
}

-(void) sendEmail:(EmailInfo *)emailInfo
{
	if (![MFMailComposeViewController canSendMail])
	{
		return;
	}
	
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	[picker setMailComposeDelegate:self];
	
	[picker setSubject:[emailInfo subject]];
	[picker setToRecipients:[NSArray arrayWithObject:[emailInfo to]]];
	[picker setMessageBody:[emailInfo message] isHTML:FALSE];
	for (NSString *fileName in [[emailInfo attachmentsByFileName] allKeys])
	{
		NSData *data = [[emailInfo attachmentsByFileName] objectForKey:fileName];
		[picker addAttachmentData:data mimeType:@"application/xml" fileName:fileName];
	}
	
	[_director presentModalViewController:picker animated:YES];
    [picker release];
}

-(void) mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{ 
	[_director dismissModalViewControllerAnimated:YES];
}

@end
