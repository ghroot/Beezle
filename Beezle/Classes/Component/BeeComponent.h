//
//  BeeComponent.h
//  Beezle
//
//  Created by Me on 02/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"
#import "BeeType.h"

@interface BeeComponent : Component
{
	BeeType *_type;
	int _beeaterHits;
	int _beeaterHitsLeft;
}

@property (nonatomic, assign) BeeType *type;

-(void) decreaseBeeaterHitsLeft;
-(BOOL) isOutOfBeeaterKills;

@end
