//
//  AppDelegate.m
//  Beezle
//
//  Created by Me on 31/10/2011.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "AppDelegate.h"
#import "EmailInfo.h"
#import "EntityDescriptionCache.h"
#import "Game.h"
#import "LevelLayoutCache.h"
#import "MainMenuState.h"
#import "SessionTracker.h"
#import "SoundManager.h"

@implementation AppDelegate

-(void) applicationDidFinishLaunching:(UIApplication *)application
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
	[glView setMultipleTouchEnabled:TRUE];
	
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
	_navigationController = [[UINavigationController alloc] initWithRootViewController:_director];
	[_navigationController setNavigationBarHidden:TRUE];
	
	// Set the Navigation Controller as the root view controller
	[_window addSubview:_navigationController.view];
	
	// Show
	[_window makeKeyAndVisible];
	
	// Tracking
	[[SessionTracker sharedTracker] start];
	
	// Setup sound
	[[SoundManager sharedManager] setup];
	
	// Boot
	_game = [[Game alloc] init];
	[_game startWithState:[MainMenuState state]];
}

-(void) dealloc
{
	[_window release];
	[_navigationController release];
	
	[_game release];
	
	[super dealloc];
}

-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

-(void) applicationWillResignActive:(UIApplication *)application
{
	if([_navigationController visibleViewController] == _director)
	{
		[_director pause];
	}
}

-(void) applicationDidBecomeActive:(UIApplication *)application
{
	if([_navigationController visibleViewController] == _director)
	{
		[_director resume];
	}
}

-(void) applicationDidEnterBackground:(UIApplication *)application
{
	if([_navigationController visibleViewController] == _director)
	{
		[_director stopAnimation];
	}
}

-(void) applicationWillEnterForeground:(UIApplication *)application
{
	if([_navigationController visibleViewController] == _director)
	{
		[_director startAnimation];
	}
}

-(void) applicationWillTerminate:(UIApplication *)application
{
	CC_DIRECTOR_END();
}

-(void) applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[[CCDirector sharedDirector] purgeCachedData];
	[[LevelLayoutCache sharedLevelLayoutCache] purgeAllCachedLevelLayouts];
	[[EntityDescriptionCache sharedCache] purgeCachedData];
}

-(void) applicationSignificantTimeChange:(UIApplication *)application
{
	[[CCDirector sharedDirector] setNextDeltaTimeZero:TRUE];
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
