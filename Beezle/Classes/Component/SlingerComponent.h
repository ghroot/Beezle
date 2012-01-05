//
//  BeeComponent.h
//  Beezle
//
//  Created by Me on 05/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"
#import "BeeTypes.h"

@interface SlingerComponent : Component
{
	NSMutableArray *_queuedBeeTypes;
	BeeTypes *_loadedBeeType;
}

@property (nonatomic, readonly) NSArray *queuedBeeTypes;
@property (nonatomic, readonly) BeeTypes *loadedBeeType;

-(void) pushBeeType:(BeeTypes *)beeType;
-(BeeTypes *) popNextBeeType;
-(BOOL) hasMoreBees;
-(void) clearBeeTypes;
-(void) loadNextBee;
-(void) clearLoadedBee;
-(BOOL) hasLoadedBee;

@end
