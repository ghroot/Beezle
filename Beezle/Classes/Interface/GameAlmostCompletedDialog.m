//
// Created by Marcus on 04/11/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "GameAlmostCompletedDialog.h"
#import "Game.h"
#import "CCBReader.h"
#import "PlayState.h"

@interface GameAlmostCompletedDialog()

-(void) exitGame;

@end

@implementation GameAlmostCompletedDialog

+(id) dialogWithGame:(Game *)game
{
	return [[[self alloc] initWithGame:game] autorelease];
}

-(id) initWithGame:(Game *)game
{
	if (self = [super initWithNode:[CCBReader nodeGraphFromFile:@"GameAlmostCompletedDialog.ccbi" owner:self] coverOpacity:128 instantCoverOpacity:TRUE])
	{
		_game = game;
	}
	return self;
}

-(void) exitGame
{
	[_game clearAndReplaceState:[PlayState state]];
}

@end
