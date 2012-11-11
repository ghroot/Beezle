//
// Created by Marcus on 11/11/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "TestCreditsState.h"
#import "CreditsDialog.h"

@implementation TestCreditsState

-(void) initialise
{
	[super initialise];

	[self addChild:[CreditsDialog dialogWithGame:_game]];
}

@end
