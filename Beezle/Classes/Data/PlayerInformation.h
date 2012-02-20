//
//  PlayerInformation.h
//  Beezle
//
//  Created by KM Lagerstrom on 18/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@interface PlayerInformation : NSObject
{
	NSMutableArray *_consumedDisposableIds;
	NSMutableArray *_consumedDisposableIdsThisLevel;
	int _numberOfCollectedPollen;
	int _numberOfCollectedPollenThisLevel;
	int _numberOfCurrentKeys;
	int _numberOfCollectedKeysThisLevel;
}

@property (nonatomic) int numberOfCollectedPollen;
@property (nonatomic, readonly) int numberOfCurrentKeys;

+(PlayerInformation *) sharedInformation;

-(void) resetForThisLevel;
-(void) storeForThisLevel;
-(void) addConsumedDisposableIdThisLevel:(NSString *)disposableId;
-(BOOL) hasConsumedDisposableId:(NSString *)disposableId;
-(void) consumedEntity:(Entity *)entity;
-(void) decrementNumberOfCurrentKeys;

@end
