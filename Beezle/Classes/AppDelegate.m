//
//  AppDelegate.m
//  Beezle
//
//  Created by Me on 31/10/2011.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "AppDelegate.h"
#import "GameLayer.h"
#import "RootViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

-(void) removeStartupFlicker
{
	//
	// THIS CODE REMOVES THE STARTUP FLICKER
	//
	// Uncomment the following code if your Application only supports landscape mode
	//

//	CC_ENABLE_DEFAULT_GL_STATES();
//	CCDirector *director = [CCDirector sharedDirector];
//	CGSize size = [director winSize];
//	CCSprite *sprite = [CCSprite spriteWithFile:@"Default.png"];
//	sprite.position = ccp(size.width/2, size.height/2);
//	sprite.rotation = -90;
//	[sprite visit];
//	[[director openGLView] swapBuffers];
//	CC_ENABLE_DEFAULT_GL_STATES();
}

-(void) applicationDidFinishLaunching:(UIApplication*)application
{
	// Init the window
	_window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	CCDirector *director = [CCDirector sharedDirector];
	
	// Init the View Controller
	_viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
	_viewController.wantsFullScreenLayout = YES;
	
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
//	if( ! [director enableRetinaDisplay:YES] )
//		CCLOG(@"Retina Display Not supported");
		
	[director setAnimationInterval:1.0f/60.0f];
	[director setDisplayFPS:TRUE];
	
	// enable multi touches
	[glView setMultipleTouchEnabled:TRUE];

	// make the OpenGLView a child of the view controller
	[_viewController setView:glView];
	
	// make the View Controller a child of the main window
	[_window addSubview: _viewController.view];
	
	[_window makeKeyAndVisible];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
	
	// PVR Textures have alpha premultiplied
	[CCTexture2D PVRImagesHavePremultipliedAlpha:YES];
	
	// Removes the startup flicker
	[self removeStartupFlicker];
	
	// Create scene
	CCScene *scene = [CCScene node];
	[scene addChild:[GameLayer node]];
	
	// TEMP: New structure
	_beezle = [[Beezle alloc] init];
	_container = [[CocosGameContainer alloc] initWithGame:_beezle];
	[scene addChild:[_container layer]];
	[container start];

	// Run the intro Scene
	[[CCDirector sharedDirector] runWithScene:scene];
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

	[_window release];
	[_viewController release];
	[_beezle release];
	[_container release];
    
	[super dealloc];
}

@end