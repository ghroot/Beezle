//
//  DestructControlSystem.m
//  Beezle
//
//  Created by Marcus Lagerstrom on 06/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DestructControlSystem.h"
#import "InputSystem.h"
#import "DestructComponent.h"
#import "TouchTypes.h"
#import "InputAction.h"
#import "EntityUtil.h"

@implementation DestructControlSystem

-(id) init
{
	self = [super initWithUsedComponentClass:[DestructComponent class]];
	return self;
}

-(void) initialise
{
	_inputSystem = (InputSystem *)[[_world systemManager] getSystem:[InputSystem class]];
}

-(void) processEntity:(Entity *)entity
{
	if ([self didTouchBegin])
	{
		[EntityUtil destroyEntity:entity];
	}
}

-(BOOL) didTouchBegin
{
	BOOL didTouchBegin = FALSE;
	while ([_inputSystem hasInputActions])
	{
		InputAction *nextInputAction = [_inputSystem popInputAction];
		if ([nextInputAction touchType] == TOUCH_BEGAN)
		{
			didTouchBegin = TRUE;
		}
	}
	return didTouchBegin;
}

@end
