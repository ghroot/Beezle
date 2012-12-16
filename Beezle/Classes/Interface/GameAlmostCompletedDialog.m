//
// Created by Marcus on 04/11/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "GameAlmostCompletedDialog.h"
#import "Game.h"
#import "CCBReader.h"
#import "PlayState.h"
#import "SoundManager.h"
#import "ActionUtils.h"

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

		[ActionUtils swaySprite:_beeSprite speed:1.5f distance:4.0f];
		[ActionUtils animateSprite:_beeSprite fileNames:[NSArray arrayWithObjects:@"End-Completed?-Bee-1.png", @"End-Completed?-Bee-2.png", nil] delay:0.1f];

		[[SoundManager sharedManager] playSound:@"GameCompleted?"];
	}
	return self;
}

-(void) exitGame
{
	[_game clearAndReplaceState:[PlayState state]];
}

@end
