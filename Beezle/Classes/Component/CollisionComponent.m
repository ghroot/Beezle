//
//  CollisionComponent.m
//  Beezle
//
//  Created by KM Lagerstrom on 15/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CollisionComponent.h"

@implementation CollisionComponent

@synthesize destroyEntityOnCollision = _destroyEntityOnCollision;
@synthesize destroyCollidingEntityOnCollision = _destroyCollidingEntityOnCollision;
@synthesize collisionAnimationName = _collisionAnimationName;
@synthesize collisionSpawnEntityType = _collisionSpawnEntityType;

-(id) init
{
	if (self = [super init])
	{
		_name = @"collision";
		_destroyEntityOnCollision = FALSE;
		_destroyCollidingEntityOnCollision = FALSE;
	}
	return self;
}

-(id) initWithContentsOfDictionary:(NSDictionary *)dict world:(World *)world
{
	if (self = [self init])
	{
		if ([dict objectForKey:@"destroyEntityOnCollision"] != nil)
		{
			_destroyEntityOnCollision = [[dict objectForKey:@"destroyEntityOnCollision"] boolValue];
		}
		if ([dict objectForKey:@"destroyCollidingEntityOnCollision"] != nil)
		{
			_destroyCollidingEntityOnCollision = [[dict objectForKey:@"destroyCollidingEntityOnCollision"] boolValue];
		}
		if ([dict objectForKey:@"collisionAnimation"] != nil)
		{
			_collisionAnimationName = [[dict objectForKey:@"collisionAnimation"] copy];
		}
		if ([dict objectForKey:@"collisionSpawnEntityType"] != nil)
		{
			_collisionSpawnEntityType = [[dict objectForKey:@"collisionSpawnEntityType"] copy];
		}
	}
	return self;
}

-(void) dealloc
{
	[_collisionAnimationName release];
	[_collisionSpawnEntityType release];
	
	[super dealloc];
}

@end
