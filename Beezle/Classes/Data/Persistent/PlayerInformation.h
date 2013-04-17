//
//  PlayerInformation.h
//  Beezle
//
//  Created by KM Lagerstrom on 18/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@class LevelSession;

@interface PlayerInformation : NSObject
{
	NSMutableDictionary *_pollenRecordByLevelName;
	NSMutableSet *_seenTutorialIds;
	NSString *_defaultTheme;
	BOOL _isSoundMuted;
	BOOL _usingAdvancedControlScheme;
	BOOL _autoAuthenticateGameCenter;
	BOOL _autoLoginToFacebook;
	int _numberOfBurnee;
	int _numberOfGoggles;
}

@property (nonatomic, copy) NSString *defaultTheme;
@property (nonatomic) BOOL isSoundMuted;
@property (nonatomic) BOOL usingAdvancedControlScheme;
@property (nonatomic) BOOL autoAuthenticateGameCenter;
@property (nonatomic) BOOL autoLoginToFacebook;
@property (nonatomic) int numberOfBurnee;
@property (nonatomic) int numberOfGoggles;

+(PlayerInformation *) sharedInformation;

-(void) initialise;
-(void) save;
-(void) reset;
-(void) store:(LevelSession *)levelSession;
-(void) storeAndSave:(LevelSession *)levelSession;
-(BOOL) isPollenRecord:(LevelSession *)levelSession;
-(int) pollenRecord:(NSString *)levelName;
-(int) totalNumberOfPollen;
-(int) flowerRecordForLevel:(NSString *)levelName;
-(int) flowerRecordForTheme:(NSString *)theme;
-(int) totalNumberOfFlowers;
-(BOOL) hasPlayedLevel:(NSString *)levelName;
-(BOOL) canPlayLevel:(NSString *)levelName;
-(BOOL) canPlayTheme:(NSString *)theme;
-(NSArray *) visibleThemes;
-(void) markTutorialIdAsSeen:(NSString *)tutorialId;
-(void) markTutorialIdAsSeenAndSave:(NSString *)tutorialId;
-(BOOL) hasSeenTutorialId:(NSString *)tutorialId;

@end
