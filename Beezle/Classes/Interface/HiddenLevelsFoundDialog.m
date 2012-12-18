//
// Created by Marcus on 14/11/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "HiddenLevelsFoundDialog.h"
#import "Game.h"
#import "CCBReader.h"
#import "ActionUtils.h"
#import "SoundManager.h"
#import "PlayState.h"
#import "LevelSession.h"
#import "LevelOrganizer.h"
#import "LevelThemeSelectMenuState.h"

@interface HiddenLevelsFoundDialog()

-(void) gotoLevelThemeSelectionState;

@end

@implementation HiddenLevelsFoundDialog

+(id) dialogWithGame:(Game *)game andLevelSession:(LevelSession *)levelSession
{
	return [[[self alloc] initWithGame:game andLevelSession:levelSession] autorelease];
}

-(id) initWithGame:(Game *)game andLevelSession:(LevelSession *)levelSession
{
	if (self = [super initWithNode:[CCBReader nodeGraphFromFile:@"HiddenLevelsFoundDialog.ccbi" owner:self] coverOpacity:128 instantCoverOpacity:TRUE])
	{
		_game = game;
		_levelSession = levelSession;

		[ActionUtils swaySprite:_beeSprite1 speed:0.8f distance:2.0f];
		[ActionUtils animateSprite:_beeSprite1 fileNames:[NSArray arrayWithObjects:@"End-GameCompleted!-Speedee-1.png", @"End-GameCompleted!-Speedee-2.png", nil] delay:0.1f];
		[ActionUtils swaySprite:_beeSprite2 speed:1.2f distance:2.0f];
		[ActionUtils animateSprite:_beeSprite2 fileNames:[NSArray arrayWithObjects:@"End-GameCompleted!-Bee-1.png", @"End-GameCompleted!-Bee-2.png", nil] delay:0.1f];
		[ActionUtils swaySprite:_beeSprite3 speed:0.6f distance:2.0f];
		[ActionUtils animateSprite:_beeSprite3 fileNames:[NSArray arrayWithObjects:@"End-GameCompleted!-Bombee-1.png", @"End-GameCompleted!-Bombee-2.png", nil] delay:0.1f];
		[ActionUtils swaySprite:_beeSprite4 speed:1.5f distance:2.0f];
		[ActionUtils animateSprite:_beeSprite4 fileNames:[NSArray arrayWithObjects:@"End-GameCompleted!-Sawee-1.png", @"End-GameCompleted!-Sawee-2.png", nil] delay:0.1f];

		[[SoundManager sharedManager] playSound:@"GameCompleted?"];
	}
	return self;
}

-(void) gotoLevelThemeSelectionState
{
	NSString *theme = [[LevelOrganizer sharedOrganizer] themeForLevel:[_levelSession levelName]];
	NSString *nextTheme = [[LevelOrganizer sharedOrganizer] themeAfter:theme];
	[_game clearAndReplaceState:[LevelThemeSelectMenuState stateWithPreselectedTheme:nextTheme]];
}

@end
