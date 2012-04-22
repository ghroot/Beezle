//
//  SolidWithBreakableCollisionHandler.m
//  Beezle
//
//  Created by KM Lagerstrom on 22/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SolidWithBreakableCollisionHandler.h"
#import "EntityUtil.h"
#import "SolidComponent.h"
#import "BreakableComponent.h"

@implementation SolidWithBreakableCollisionHandler

-(id) initWithWorld:(World *)world levelSession:(LevelSession *)levelSession
{
	if (self = [super initWithWorld:world levelSession:levelSession])
	{
		[_firstComponentClasses addObject:[SolidComponent class]];
		[_secondComponentClasses addObject:[BreakableComponent class]];
	}
	return self;
}

-(BOOL) handleCollisionBetween:(Entity *)firstEntity and:(Entity *)secondEntity collision:(Collision *)collision
{
	Entity *breakableEntity = secondEntity;
	[EntityUtil destroyEntity:breakableEntity];
	return TRUE;
}

@end
