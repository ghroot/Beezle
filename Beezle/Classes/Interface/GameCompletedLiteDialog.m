//
// Created by Marcus on 12/12/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "GameCompletedLiteDialog.h"
#import "Game.h"
#import "CCBReader.h"
#import "ActionUtils.h"
#import "SoundManager.h"
#import "PlayState.h"
#import "LiteUtils.h"

@interface GameCompletedLiteDialog()

-(void) gotoAppStore;
-(void) exitGame;

@end

@implementation GameCompletedLiteDialog

+(id) dialogWithGame:(Game *)game
{
	return [[[self alloc] initWithGame:game] autorelease];
}

-(id) initWithGame:(Game *)game
{
	if (self = [super initWithNode:[CCBReader nodeGraphFromFile:@"GameCompletedLiteDialog.ccbi" owner:self] coverOpacity:128 instantCoverOpacity:TRUE])
	{
		_game = game;

		[ActionUtils swaySprite:_beeSprite1 speed:1.5f distance:2.0f];
		[ActionUtils animateSprite:_beeSprite1 fileNames:[NSArray arrayWithObjects:@"End-GameCompleted!-Sawee-1.png", @"End-GameCompleted!-Sawee-2.png", nil] delay:0.1f];
		[ActionUtils swaySprite:_beeSprite2 speed:1.1f distance:2.0f];
		[ActionUtils animateSprite:_beeSprite2 fileNames:[NSArray arrayWithObjects:@"End-GameCompleted!-Sumee-1.png", @"End-GameCompleted!-Sumee-2.png", nil] delay:0.1f];
		[ActionUtils swaySprite:_beeSprite3 speed:1.2f distance:2.0f];
		[ActionUtils animateSprite:_beeSprite3 fileNames:[NSArray arrayWithObjects:@"End-Completed?-Bee-1.png", @"End-Completed?-Bee-2.png", nil] delay:0.1f];
		[ActionUtils swaySprite:_beeSprite4 speed:0.6f distance:2.0f];
		[ActionUtils animateSprite:_beeSprite4 fileNames:[NSArray arrayWithObjects:@"End-GameCompleted!-Bombee-1.png", @"End-GameCompleted!-Bombee-2.png", nil] delay:0.1f];
		[ActionUtils swaySprite:_beeSprite5 speed:0.8f distance:2.0f];
		[ActionUtils animateSprite:_beeSprite5 fileNames:[NSArray arrayWithObjects:@"End-GameCompleted!-Speedee-1.png", @"End-GameCompleted!-Speedee-2.png", nil] delay:0.1f];
		[ActionUtils swaySprite:_beeSprite6 speed:0.9f distance:2.0f];
		[ActionUtils animateSprite:_beeSprite6 fileNames:[NSArray arrayWithObjects:@"End-GameCompleted!-TBee-1.png", @"End-GameCompleted!-TBee-2.png", nil] delay:0.1f];

		[[SoundManager sharedManager] stopMusic];
		[[SoundManager sharedManager] playSound:@"GameCompleted?"];
	}
	return self;
}

-(void) gotoAppStore
{
	[[LiteUtils sharedUtils] gotoAppStoreForFullVersion];
}

-(void) exitGame
{
	[_game clearAndReplaceState:[PlayState state]];
}

@end
