//
// Created by Marcus on 13/11/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//

@interface GameCenterManager : NSObject <GKGameCenterControllerDelegate, GKLeaderboardViewControllerDelegate>
{
	BOOL _isAuthenticated;
	BOOL _showLeaderBoardsOnceAuthenticated;
}

@property (nonatomic, readonly) BOOL isAuthenticated;

+(GameCenterManager *) sharedManager;

-(void) authenticate;
-(void) showLeaderboards;
-(void) reportScore:(int)score;

@end
