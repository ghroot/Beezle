//
// Created by Marcus on 14/11/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "BeezleNavigationViewController.h"

@implementation BeezleNavigationViewController

-(BOOL) shouldAutorotate
{
	return TRUE;
}

-(NSUInteger) supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskLandscapeLeft;
}

-(UIInterfaceOrientation) preferredInterfaceOrientationForPresentation
{
	return UIInterfaceOrientationLandscapeLeft;
}

@end
