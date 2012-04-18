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
@synthesize collisionAnimationName = _collisionAnimationName;

-(id) init
{
	if (self = [super init])
	{
		_name = @"collision";
		_destroyEntityOnCollision = FALSE;
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
		if ([dict objectForKey:@"collisionAnimation"] != nil)
		{
			_collisionAnimationName = [[dict objectForKey:@"collisionAnimation"] copy];
		}
	}
	return self;
}

-(void) dealloc
{
	[_collisionAnimationName release];
	
	[super dealloc];
}

@end
