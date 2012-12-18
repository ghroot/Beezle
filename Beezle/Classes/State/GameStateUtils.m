//
//  GameStateUtils.m
//  Beezle
//
//  Created by Marcus Lagerstrom on 08/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameStateUtils.h"
#import "TutorialStripDescription.h"
#import "TutorialOrganizer.h"
#import "PlayerInformation.h"
#import "Game.h"
#import "TutorialStripMenuState.h"
#import "Game.h"
#import "GameplayState.h"

@implementation GameStateUtils

+(void) replaceWithGameplayState:(NSString *)levelName game:(Game *)game
{
	TutorialStripDescription *tutorialStripDescription = [[TutorialOrganizer sharedOrganizer] unseenTutorialStripDescriptionForLevel:levelName];
	if (tutorialStripDescription != nil)
	{
		TutorialStripMenuState *tutorialStripMenuState = [[[TutorialStripMenuState alloc] initWithFileName:[tutorialStripDescription fileName] buttonFileName:[tutorialStripDescription buttonFileName] block:^{
			[game clearAndReplaceState:[GameplayState stateWithLevelName:levelName]];
		}] autorelease];
		[game pushState:tutorialStripMenuState];

		[[PlayerInformation sharedInformation] markTutorialIdAsSeenAndSave:[tutorialStripDescription id]];
	}
	else
	{
		[game clearAndReplaceState:[GameplayState stateWithLevelName:levelName]];
	}
}

@end
