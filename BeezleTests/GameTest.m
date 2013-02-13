//
//  Beezle - GameTest.m
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//
//  Created by: Marcus Lagerstrom
//

    // Class under test
#import "Game.h"

    // Collaborators
#import "GameState.h"

    // Test support
#import <SenTestingKit/SenTestingKit.h>

// Uncomment the next two lines to use OCHamcrest for test assertions:
#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

// Uncomment the next two lines to use OCMockito for mock objects:
#define MOCKITO_SHORTHAND
#import <OCMockitoIOS/OCMockitoIOS.h>


@interface GameTest : SenTestCase
@end

@implementation GameTest
{
    // test fixture ivars go here
}

-(void) test_whenStartingWithState_makesStateCurrentState
{
	CCDirector *director = mock([CCDirector class]);
	
	GameState *gameState1 = mock([GameState class]);
	[given([gameState1 needsLoadingState]) willReturn:FALSE];
	
	Game *game = [[[Game alloc] initWithDirector:director] autorelease];
	
	[game startWithState:gameState1];
	
	STAssertEqualObjects(gameState1, [game currentState], @"Should make state the current state");
}

-(void) test_whenStartingWithState_entersState
{
	CCDirector *director = mock([CCDirector class]);
	
	GameState *gameState1 = mock([GameState class]);
	[given([gameState1 needsLoadingState]) willReturn:FALSE];
	
	Game *game = [[[Game alloc] initWithDirector:director] autorelease];
	
	[game startWithState:gameState1];
	
	[verifyCount(gameState1, times(1)) enter];
}

-(void) test_whenPushingState_makesStateCurrentState_andKeepsPreviousState
{
	CCDirector *director = mock([CCDirector class]);
	
	GameState *gameState1 = mock([GameState class]);
	[given([gameState1 needsLoadingState]) willReturn:FALSE];
	
	GameState *gameState2 = mock([GameState class]);
	[given([gameState2 needsLoadingState]) willReturn:FALSE];
	
	Game *game = [[[Game alloc] initWithDirector:director] autorelease];
	
	[game startWithState:gameState1];
	
	[game pushState:gameState2 transition:FALSE];
	
	STAssertEqualObjects(gameState2, [game currentState], @"Pushing should make state current state");
	STAssertEqualObjects(gameState1, [game previousState], @"Pusing should keep previous state");
}

-(void) test_whenPushingState_leavesCurrentState_andEntersNewState
{
	CCDirector *director = mock([CCDirector class]);
	
	GameState *gameState1 = mock([GameState class]);
	[given([gameState1 needsLoadingState]) willReturn:FALSE];
	
	GameState *gameState2 = mock([GameState class]);
	[given([gameState2 needsLoadingState]) willReturn:FALSE];
	
	Game *game = [[[Game alloc] initWithDirector:director] autorelease];
	
	[game startWithState:gameState1];
	
	[game pushState:gameState2 transition:FALSE];
	
	[verifyCount(gameState1, times(1)) leave];
	[verifyCount(gameState2, times(1)) enter];
}

-(void) test_whenPoppingState_makesPreviousStateCurrentState
{
	CCDirector *director = mock([CCDirector class]);
	
	GameState *gameState1 = mock([GameState class]);
	[given([gameState1 needsLoadingState]) willReturn:FALSE];
	
	GameState *gameState2 = mock([GameState class]);
	[given([gameState2 needsLoadingState]) willReturn:FALSE];
	
	Game *game = [[[Game alloc] initWithDirector:director] autorelease];
	
	[game startWithState:gameState1];
	[game pushState:gameState2 transition:FALSE];
	
	[game popStateWithTransition:FALSE];
	
	STAssertEqualObjects(gameState1, [game currentState], @"Popping should make previous state current state");
}

-(void) test_whenPoppingState_leavesCurrentState_andEntersPreviouState
{
	CCDirector *director = mock([CCDirector class]);
	
	GameState *gameState1 = mock([GameState class]);
	[given([gameState1 needsLoadingState]) willReturn:FALSE];
	
	GameState *gameState2 = mock([GameState class]);
	[given([gameState2 needsLoadingState]) willReturn:FALSE];
	
	Game *game = [[[Game alloc] initWithDirector:director] autorelease];
	
	[game startWithState:gameState1];
	[game pushState:gameState2 transition:FALSE];
	
	[game popStateWithTransition:FALSE];
	
	[verifyCount(gameState1, times(2)) enter];
	[verifyCount(gameState2, times(1)) leave];
}

-(void) test_whenReplacingState_replacesCurrentState_andKeepsPreviousState
{
	CCDirector *director = mock([CCDirector class]);
	
	GameState *gameState1 = mock([GameState class]);
	[given([gameState1 needsLoadingState]) willReturn:FALSE];
	
	GameState *gameState2 = mock([GameState class]);
	[given([gameState2 needsLoadingState]) willReturn:FALSE];
	
	GameState *gameState3 = mock([GameState class]);
	[given([gameState3 needsLoadingState]) willReturn:FALSE];
	
	Game *game = [[[Game alloc] initWithDirector:director] autorelease];
	
	[game startWithState:gameState1];
	[game pushState:gameState2 transition:FALSE];
	
	[game replaceState:gameState3 transition:FALSE];
	
	STAssertEqualObjects(gameState3, [game currentState], @"Replacing should make state current state");
	STAssertEqualObjects(gameState1, [game previousState], @"Replacing should keep previous state");
}

-(void) test_whenReplacingState_leavesCurrentState_andEntersNewState
{
	CCDirector *director = mock([CCDirector class]);
	
	GameState *gameState1 = mock([GameState class]);
	[given([gameState1 needsLoadingState]) willReturn:FALSE];
	
	GameState *gameState2 = mock([GameState class]);
	[given([gameState2 needsLoadingState]) willReturn:FALSE];
	
	GameState *gameState3 = mock([GameState class]);
	[given([gameState3 needsLoadingState]) willReturn:FALSE];
	
	Game *game = [[[Game alloc] initWithDirector:director] autorelease];
	
	[game startWithState:gameState1];
	[game pushState:gameState2 transition:FALSE];
	
	[game replaceState:gameState3 transition:FALSE];
	
	[verifyCount(gameState2, times(1)) leave];
	[verifyCount(gameState3, times(1)) enter];
}

-(void) test_whenClearingAndReplacingState_makesStateOnlyState
{
	CCDirector *director = mock([CCDirector class]);
	
	GameState *gameState1 = mock([GameState class]);
	[given([gameState1 needsLoadingState]) willReturn:FALSE];
	
	GameState *gameState2 = mock([GameState class]);
	[given([gameState2 needsLoadingState]) willReturn:FALSE];
	
	GameState *gameState3 = mock([GameState class]);
	[given([gameState3 needsLoadingState]) willReturn:FALSE];
	
	Game *game = [[[Game alloc] initWithDirector:director] autorelease];
	
	[game startWithState:gameState1];
	[game pushState:gameState2 transition:FALSE];
	
	[game clearAndReplaceState:gameState3 transition:FALSE];
	
	STAssertEqualObjects(gameState3, [game currentState], @"Clearing should make state current state");
	STAssertNil([game previousState], @"Clearing should remove all states but the active state");
}

-(void) test_whenClearingAndReplacingState_leavesCurrentState_andEntersNewState_andDoesNotLeaveOtherStates
{
	CCDirector *director = mock([CCDirector class]);
	
	GameState *gameState1 = mock([GameState class]);
	[given([gameState1 needsLoadingState]) willReturn:FALSE];
	
	GameState *gameState2 = mock([GameState class]);
	[given([gameState2 needsLoadingState]) willReturn:FALSE];
	
	GameState *gameState3 = mock([GameState class]);
	[given([gameState3 needsLoadingState]) willReturn:FALSE];
	
	Game *game = [[[Game alloc] initWithDirector:director] autorelease];
	
	[game startWithState:gameState1];
	[game pushState:gameState2 transition:FALSE];
	
	[game clearAndReplaceState:gameState3 transition:FALSE];
	
	[verifyCount(gameState2, times(1)) leave];
	[verifyCount(gameState3, times(1)) enter];
	[verifyCount(gameState1, times(1)) leave];
}

@end
