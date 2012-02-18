//
//  AppDelegate.h
//  Beezle
//
//  Created by Me on 31/10/2011.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "cocos2d.h"

@class EmailInfo;
@class Game;
@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate, MFMailComposeViewControllerDelegate, CCDirectorDelegate>
{
	UIWindow *_window;
	UINavigationController *_navigationController;
	CCDirectorIOS *_director;
    
    Game *_game;
}

-(void) sendEmail:(EmailInfo *)emailInfo;

@end
