//
//  AnythingWithVoidCollisionHandler.m
//  Beezle
//
//  Created by KM Lagerstrom on 22/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AnythingWithVoidCollisionHandler.h"
#import "Collision.h"
#import "EntityUtil.h"
#import "VoidComponent.h"
#import "DisposableComponent.h"

@implementation AnythingWithVoidCollisionHandler

-(id) initWithWorld:(World *)world levelSession:(LevelSession *)levelSession
{
	if (self = [super initWithWorld:world levelSession:levelSession])
	{
		[_secondComponentClasses addObject:[VoidComponent class]];
	}
	return self;
}

-(BOOL) handleCollisionBetween:(Entity *)firstEntity and:(Entity *)secondEntity collision:(Collision *)collision
{
	Entity *voidEntity = secondEntity;

	if ([EntityUtil isEntityDisposable:voidEntity] &&
		[[DisposableComponent getFrom:voidEntity] isAboutToBeDeleted])
	{
		return TRUE;
	}

	VoidComponent *voidComponent = [VoidComponent getFrom:voidEntity];
	[EntityUtil destroyEntity:firstEntity instant:[voidComponent instant]];

	return FALSE;
}

@end
