//
//  AnythingWithVolatileCollisionHandler.m
//  Beezle
//
//  Created by KM Lagerstrom on 22/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AnythingWithVolatileCollisionHandler.h"
#import "EntityUtil.h"
#import "VolatileComponent.h"

@implementation AnythingWithVolatileCollisionHandler

-(id) initWithWorld:(World *)world levelSession:(LevelSession *)levelSession
{
	if (self = [super initWithWorld:world levelSession:levelSession])
	{
		[_secondComponentClasses addObject:[VolatileComponent class]];
	}
	return self;
}

-(BOOL) handleCollisionBetween:(Entity *)firstEntity and:(Entity *)secondEntity collision:(Collision *)collision
{
	Entity *volatileEntity = secondEntity;
	[EntityUtil destroyEntity:volatileEntity];
	return TRUE;
}

@end
