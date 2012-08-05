//
//  TeleportInfo.h
//  Beezle
//
//  Created by Marcus Lagerstrom on 08/05/12.
//Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@interface TeleportInfo : NSObject
{
	Entity *_entity;
	int _countdown;
}

@property (nonatomic, readonly) Entity *entity;

-(id) initWithEntity:(Entity *)entity;

-(BOOL) hasCountdownReachedZero;
-(void) decreaseCountdown;

@end
