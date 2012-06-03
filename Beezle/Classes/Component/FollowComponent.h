//
//  FollowComponent
//  Beezle
//
//  Created by marcus on 01/06/2012.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

typedef enum
{
	FOLLOW_CONTROL_STATE_INACTIVE,
	FOLLOW_CONTROL_STATE_ACTIVE,
} FollowControlState;

@interface FollowComponent : Component
{
	// Transient
	FollowControlState _state;
	CGPoint _location;
}

@property (nonatomic) FollowControlState state;
@property (nonatomic) CGPoint location;

@end