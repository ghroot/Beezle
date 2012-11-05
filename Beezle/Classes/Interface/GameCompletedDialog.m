//
// Created by Marcus on 04/11/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "GameCompletedDialog.h"
#import "PlayState.h"
#import "Game.h"
#import "CCBReader.h"
#import "GameplayState.h"
#import "CreditsDialog.h"
#import "SoundManager.h"

@interface GameCompletedDialog()

-(void) showCredits;

@end

@implementation GameCompletedDialog

+(id) dialogWithGame:(Game *)game
{
	return [[[self alloc] initWithGame:game] autorelease];
}

-(id) initWithGame:(Game *)game
{
	if (self = [super initWithNode:[CCBReader nodeGraphFromFile:@"GameCompletedDialog.ccbi" owner:self] coverOpacity:128 instantCoverOpacity:TRUE])
	{
		_game = game;

		[[SoundManager sharedManager] playSound:@"LevelCompleted"];
	}
	return self;
}

-(void) showCredits
{
	GameplayState *gameplayState = (GameplayState *)[_game currentState];
	[gameplayState closeAllDialogs];
	[[gameplayState uiLayer] addChild:[CreditsDialog dialogWithGame:_game]];
}

@end
