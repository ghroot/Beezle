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
	// Type
	BOOL _alwaysActive;
	NSString *_locationAnimationFile;
	NSString *_locationAnimationName;

	// Transient
	FollowControlState _state;
	CGPoint _location;
	Entity *_locationEntity;
}

@property (nonatomic) BOOL alwaysActive;
@property (nonatomic, copy) NSString *locationAnimationFile;
@property (nonatomic, copy) NSString *locationAnimationName;
@property (nonatomic) FollowControlState state;
@property (nonatomic) CGPoint location;
@property (nonatomic, assign) Entity * locationEntity;

@end