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
}

@property (nonatomic) int numberOfCollectedPollen;

+(PlayerInformation *) sharedInformation;

-(void) resetForThisLevel;
-(void) storeForThisLevel;
-(void) addConsumedDisposableIdThisLevel:(NSString *)disposableId;
-(BOOL) hasConsumedDisposableId:(NSString *)disposableId;
-(void) consumedEntity:(Entity *)entity;

@end
