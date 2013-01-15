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
-(void) didRecieveUids:(NSArray *)uids names:(NSArray *)names scores:(NSArray *)scores;
-(void) failedToGetScores;

@end

@interface FacebookManager : NSObject
{
	Facebook *_facebook;
	BOOL _isLoggedIn;
	long long _playerFBID;
	NSString *_playerName;
	id<FacebookScoresDelegate> _delegate;
}

@property (nonatomic, readonly) BOOL isLoggedIn;
@property (nonatomic, readonly) long long playerFBID;
@property (nonatomic, assign) id<FacebookScoresDelegate> delegate;

+(FacebookManager *) sharedManager;

-(void) login;
-(void) postScore:(int)score;
-(void) getScores;

@end
