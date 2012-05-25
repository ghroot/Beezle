//
//  CollisionHandler.m
//  Beezle
//
//  Created by KM Lagerstrom on 22/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CollisionHandler.h"
#import "Collision.h"

@interface CollisionHandler()

-(BOOL) shouldHandleCollision:(Collision *)collision;
-(BOOL) shouldHandleCollisionReversed:(Collision *)collision;

@end

@implementation CollisionHandler

+(id) handlerWithWorld:(World *)world levelSession:(LevelSession *)levelSession
{
	return [[[self alloc] initWithWorld:world levelSession:levelSession] autorelease];
}

-(id) initWithWorld:(World *)world levelSession:(LevelSession *)levelSession
{
	if (self = [super init])
	{
		_world = world;
		_levelSession = levelSession;
		_firstComponentClasses = [NSMutableArray new];
		_secondComponentClasses = [NSMutableArray new];
	}
	return self;
}

-(void) dealloc
{
	[_firstComponentClasses release];
	[_secondComponentClasses release];
	
	[super dealloc];
}

-(BOOL) handleCollision:(Collision *)collision
{
	if ([self shouldHandleCollision:collision])
	{
		return [self handleCollisionBetween:[collision firstEntity] and:[collision secondEntity] collision:collision];
	}
	else if ([self shouldHandleCollisionReversed:collision])
	{
		Collision *reversedCollision = [Collision collisionWithFirstShape:[collision secondShape] andSecondShape:[collision firstShape]];
		return [self handleCollisionBetween:[reversedCollision firstEntity] and:[reversedCollision secondEntity] collision:reversedCollision];
	}
	else
	{
		return TRUE;
	}
}

-(BOOL) shouldHandleCollision:(Collision *)collision
{
	for (Class firstComponentClass in _firstComponentClasses)
	{
		if (![[collision firstEntity] hasComponent:firstComponentClass])
		{
			return FALSE;
		}
	}
	for (Class secondComponentClass in _secondComponentClasses)
	{
		if (![[collision secondEntity] hasComponent:secondComponentClass])
		{
			return FALSE;
		}
	}
	return TRUE;
}

-(BOOL) shouldHandleCollisionReversed:(Collision *)collision
{
	for (Class firstComponentClass in _firstComponentClasses)
	{
		if (![[collision secondEntity] hasComponent:firstComponentClass])
		{
			return FALSE;
		}
	}
	for (Class secondComponentClass in _secondComponentClasses)
	{
		if (![[collision firstEntity] hasComponent:secondComponentClass])
		{
			return FALSE;
		}
	}
	return TRUE;
}

// Override in subclasses
-(BOOL) handleCollisionBetween:(Entity *)firstEntity and:(Entity *)secondEntity collision:(Collision *)collision
{
	return TRUE;
}

@end
