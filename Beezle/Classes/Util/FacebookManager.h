//
//  FacebookManager.h
//  Beezle
//
//  Created by Marcus Lagerstrom on 01/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "Facebook.h"
#import "cocos2d.h"

@protocol FacebookScoresDelegate <NSObject>

-(void) didLogin;
-(void) loginFailed;
-(void) didRecieveUids:(NSArray *)uids names:(NSArray *)names scores:(NSArray *)scores;
-(void) failedToGetScores;
-(void) failedToPostScore;

@end

@interface FacebookManager : NSObject
{
	Facebook *_facebook;
	BOOL _isLoggedIn;
	BOOL _hasPublishPermission;
	BOOL _haveAskedForPublishPermissions;
	id<FacebookScoresDelegate> _delegate;
}

@property (nonatomic, readonly) BOOL isLoggedIn;
@property (nonatomic, assign) id<FacebookScoresDelegate> delegate;

+(FacebookManager *) sharedManager;

-(void) login;
-(void) closeSession;
-(void) handleDidBecomeActive;
-(void) getScores;
-(void) tryPostScore:(int)score;
-(void) handleOpenURL:(NSURL *)url;

@end
