//
//  AppDelegate.m
//  Beezle
//
//  Created by Me on 31/10/2011.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "AppDelegate.h"
#import "Game.h"
#import "RootViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

-(void) applicationDidFinishLaunching:(UIApplication*)application
{
	// Init the window
	_window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	CCDirector *director = [CCDirector sharedDirector];
	
	// Init the View Controller
	_viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
	_viewController.wantsFullScreenLayout = TRUE;
	
	//
	// Create the EAGLView manually
	//  1. Create a RGB565 format. Alternative: RGBA8
	//	2. depth format of 0 bit. Use 16 or 24 bit for 3d effects, like CCPageTurnTransition
	//
	//
	EAGLView *glView = [EAGLView viewWithFrame:[_window bounds]
								   pixelFormat:kEAGLColorFormatRGB565	// kEAGLColorFormatRGBA8
								   depthFormat:0						// GL_DEPTH_COMPONENT16_OES
						];
	
	// attach the openglView to the director
	[director setOpenGLView:glView];
	
	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	if(![director enableRetinaDisplay:TRUE])
    {
		CCLOG(@"Retina Display Not supported");
    }

    // Settings
	[[CCDirector sharedDirector] setAnimationInterval:(1.0f / 60.0f)];
    [director setDisplayStats:kCCDirectorStatsFPS];
    [director setProjection:kCCDirectorProjection2D];
    [director setDepthTest:FALSE];
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
    [CCTexture2D PVRImagesHavePremultipliedAlpha:TRUE];

	// Make the OpenGLView a child of the view controller
	[_viewController setView:glView];
	
	// Make the View Controller a child of the main window
	[_window addSubview: _viewController.view];
	
	[_window makeKeyAndVisible];
	
    // Create game
    _game = [[Game alloc] init];
	[_game startWithState:[MainMenuState state]];
}

-(void) applicationWillResignActive:(UIApplication *)application
{
	[[CCDirector sharedDirector] pause];
}

-(void) applicationDidBecomeActive:(UIApplication *)application
{
	[[CCDirector sharedDirector] resume];
}

-(void) applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application
{
	[[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application
{
	[[CCDirector sharedDirector] startAnimation];
}

-(void) applicationWillTerminate:(UIApplication *)application
{
	CCDirector *director = [CCDirector sharedDirector];
	
	[[director openGLView] removeFromSuperview];
	
	[_viewController release];
	
	[_window release];
	
	[director end];	
}

-(void) applicationSignificantTimeChange:(UIApplication *)application
{
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

-(void) dealloc
{
	[[CCDirector sharedDirector] end];
	
	[_game release];

	[_window release];
	[_viewController release];
    
	[super dealloc];
}

@end
