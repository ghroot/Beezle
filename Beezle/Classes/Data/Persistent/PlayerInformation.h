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
}

+(PlayerInformation *) sharedInformation;

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
-(BOOL) canPlayLevel:(NSString *)levelName;
-(void) markTutorialIdAsSeen:(NSString *)tutorialId;
-(void) markTutorialIdAsSeenAndSave:(NSString *)tutorialId;
-(BOOL) hasSeenTutorialId:(NSString *)tutorialId;

@end
