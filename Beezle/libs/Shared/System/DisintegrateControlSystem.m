//
//  DisintegrateControlSystem.m
//  Beezle
//
//  Created by Marcus Lagerstrom on 06/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DisintegrateControlSystem.h"
#import "InputSystem.h"
#import "DisintegrateComponent.h"
#import "TouchTypes.h"
#import "InputAction.h"
#import "EntityUtil.h"

@implementation DisintegrateControlSystem

-(id) init
{
	self = [super initWithUsedComponentClass:[DisintegrateComponent class]];
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
