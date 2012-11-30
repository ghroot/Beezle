//
// Created by Marcus on 13/11/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//

@interface GameCenterManager : NSObject <GKGameCenterControllerDelegate, GKLeaderboardViewControllerDelegate>
{
	BOOL _isAuthenticated;
}

@property (nonatomic, readonly) BOOL isAuthenticated;

+(GameCenterManager *) sharedManager;

-(void) initialise;
-(void) showLeaderboards;
-(void) reportScore:(int)score;

@end
