//
//  AppDelegate.h
//  Beezle
//
//  Created by Me on 31/10/2011.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

@class Beezle;
@class CocosGameContainer;
@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate>
{
	UIWindow *_window;
	RootViewController *_viewController;
	
	CocosGameContainer *_container;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) RootViewController *viewController;

@end
