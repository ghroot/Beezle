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
	NSMutableDictionary *_pollenCollectionRecordByLevelName;
	NSMutableArray *_levelNamesWhereKeysWereCollected;
	NSMutableArray *_levelNamesWhereKeysWereUsed;
}

+(PlayerInformation *) sharedInformation;

-(void) save;
-(void) reset;
-(void) store:(LevelSession *)levelSession;
-(void) storeAndSave:(LevelSession *)levelSession;
-(BOOL) isPollenRecord:(LevelSession *)levelSession;
-(BOOL) hasCollectedKeyInLevel:(NSString *)levelName;
-(BOOL) hasUsedKeyInLevel:(NSString *)levelName;
-(int) totalNumberOfCollectedPollen;
-(int) totalNumberOfKeys;

@end