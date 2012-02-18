//
//  AppDelegate.m
//  Beezle
//
//  Created by Me on 31/10/2011.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "AppDelegate.h"
#import "BootStrap.h"
#import "EmailInfo.h"
#import "Game.h"

@implementation AppDelegate

-(void) applicationDidFinishLaunching:(UIApplication*)application
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
	_director.wantsFullScreenLayout = YES;
	
	// Attach the openglView to the director
	[_director setView:glView];
	
	// Settings
	[_director setAnimationInterval:(1.0f / 60.0f)];
	//	[_director setDisplayStats:TRUE];
	[_director setProjection:kCCDirectorProjection2D];
	[_director setDepthTest:FALSE];
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
	[CCTexture2D PVRImagesHavePremultipliedAlpha:TRUE];
	
	// For rotation and other messages
	[_director setDelegate:self];
	
	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	if(![_director enableRetinaDisplay:TRUE])
    {
		CCLOG(@"Retina Display Not supported");
    }
	
	// Create a Navigation Controller with the Director
	_navigationController = [[UINavigationController alloc] initWithRootViewController:_director];
	_navigationController.navigationBarHidden = YES;
	
	// Set the Navigation Controller as the root view controller
	[_window addSubview:_navigationController.view];
	
	// Show
	[_window makeKeyAndVisible];
	
	// Boot
	_game = [[Game alloc] init];
	BootStrap *bootStrap = [[[BootStrap alloc] initWithGame:_game] autorelease];
	[bootStrap start];
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

-(void) applicationDidEnterBackground:(UIApplication*)application
{
	if([_navigationController visibleViewController] == _director)
	{
		[_director stopAnimation];
	}
}

-(void) applicationWillEnterForeground:(UIApplication*)application
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
	picker.mailComposeDelegate = self;
	
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

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{ 
	[_director dismissModalViewControllerAnimated:YES];
}

- (void) dealloc
{
	[_window release];
	[_navigationController release];
	
	[_game release];
	
	[super dealloc];
}

@end
