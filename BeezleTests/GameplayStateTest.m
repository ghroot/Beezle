//
//  Beezle - GameplayStateTest.m
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//
//  Created by: Marcus Lagerstrom
//

    // Class under test
#import "GameplayState.h"

    // Collaborators

    // Test support
#import <SenTestingKit/SenTestingKit.h>

// Uncomment the next two lines to use OCHamcrest for test assertions:
//#define HC_SHORTHAND
//#import <OCHamcrestIOS/OCHamcrestIOS.h>

// Uncomment the next two lines to use OCMockito for mock objects:
#define MOCKITO_SHORTHAND
#import <OCMockitoIOS/OCMockitoIOS.h>


@interface GameplayStateTest : SenTestCase
@end

@implementation GameplayStateTest
{
    // test fixture ivars go here
}

- (void)testExample
{
	GameplayState *gameplayState = [GameplayState stateWithLevelName:@"fakeLevelName"];
	
	STAssertNotNil(gameplayState, @"is nil");
}

@end
