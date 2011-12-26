//
//  RootViewController.h
//  Beezle
//
//  Created by Me on 31/10/2011.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "cocos2d.h"

@class EmailInfo;

@interface RootViewController : UIViewController <MFMailComposeViewControllerDelegate>

-(void) displayComposer:(EmailInfo *)emailInfo;

@end
