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
#import "ActionUtils.h"
#import "LiteUtils.h"

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

		[ActionUtils swaySprite:_beeSprite1 speed:1.5f distance:2.0f];
		[ActionUtils animateSprite:_beeSprite1 fileNames:[NSArray arrayWithObjects:@"End-GameCompleted!-Sawee-1.png", @"End-GameCompleted!-Sawee-2.png", nil] delay:0.1f];
		[ActionUtils swaySprite:_beeSprite2 speed:1.1f distance:2.0f];
		[ActionUtils animateSprite:_beeSprite2 fileNames:[NSArray arrayWithObjects:@"End-GameCompleted!-Sumee-1.png", @"End-GameCompleted!-Sumee-2.png", nil] delay:0.1f];
		[ActionUtils swaySprite:_beeSprite3 speed:0.6f distance:2.0f];
		[ActionUtils animateSprite:_beeSprite3 fileNames:[NSArray arrayWithObjects:@"End-GameCompleted!-Bombee-1.png", @"End-GameCompleted!-Bombee-2.png", nil] delay:0.1f];
		[ActionUtils swaySprite:_beeSprite4 speed:1.2f distance:2.0f];
		[ActionUtils animateSprite:_beeSprite4 fileNames:[NSArray arrayWithObjects:@"End-GameCompleted!-Bee-1.png", @"End-GameCompleted!-Bee-2.png", nil] delay:0.1f];
		[ActionUtils swaySprite:_beeSprite5 speed:0.8f distance:2.0f];
		[ActionUtils animateSprite:_beeSprite5 fileNames:[NSArray arrayWithObjects:@"End-GameCompleted!-Speedee-1.png", @"End-GameCompleted!-Speedee-2.png", nil] delay:0.1f];
		[ActionUtils swaySprite:_beeSprite6 speed:0.9f distance:2.0f];
		[ActionUtils animateSprite:_beeSprite6 fileNames:[NSArray arrayWithObjects:@"End-GameCompleted!-TBee-1.png", @"End-GameCompleted!-TBee-2.png", nil] delay:0.1f];
		[ActionUtils swaySprite:_beeSprite7 speed:1.0f distance:2.0f];
		[ActionUtils animateSprite:_beeSprite7 fileNames:[NSArray arrayWithObjects:@"End-GameCompleted!-Mumee-1.png", @"End-GameCompleted!-Mumee-2.png", nil] delay:0.1f];

		[[SoundManager sharedManager] playSound:@"GameCompleted!"];
	}
	return self;
}

-(void) showCredits
{
#ifdef LITE_VERSION
	[_game clearAndReplaceState:[PlayState state]];
	[[LiteUtils sharedUtils] showBuyFullVersionAlert];
#else
	GameplayState *gameplayState = (GameplayState *)[_game currentState];
	[gameplayState closeAllDialogs];
	[[gameplayState uiLayer] addChild:[CreditsDialog dialogWithGame:_game]];
#endif
}

@end
