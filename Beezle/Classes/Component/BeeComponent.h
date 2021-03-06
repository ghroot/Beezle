//
//  BeeComponent.h
//  Beezle
//
//  Created by Me on 02/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"
#import "BeeType.h"

/**
  Bee specific.
 */
@interface BeeComponent : Component
{
    // Type
	BeeType *_type;
    
    // Transient
	int _beeaterHitsLeft;
	int _autoDestroyCountdown;
}

@property (nonatomic, assign) BeeType *type;

-(BOOL) killsBeeaters;
-(void) resetBeeaterHitsLeft;
-(void) decreaseBeeaterHitsLeft;
-(BOOL) isOutOfBeeaterKills;
-(void) resetAutoDestroyCountdown;
-(void) decreaseAutoDestroyCountdown:(float)time;
-(BOOL) didAutoDestroyCountdownReachZero;

@end
