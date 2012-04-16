//
//  CollisionComponent.m
//  Beezle
//
//  Created by KM Lagerstrom on 15/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CollisionComponent.h"

@implementation CollisionComponent

@synthesize disposeEntityOnCollision = _disposeEntityOnCollision;
@synthesize disposeAnimateAndDeleteEntityOnCollision = _disposeAnimateAndDeleteEntityOnCollision;
@synthesize disposeAndDeleteBeeOnCollision = _disposeAndDeleteBeeOnCollision;
@synthesize disposeAnimateAndDeleteBeeOnCollision = _disposeAnimateAndDeleteBeeOnCollision;
@synthesize collisionAnimationName = _collisionAnimationName;

-(id) init
{
	if (self = [super init])
	{
		_name = @"collision";
		_disposeEntityOnCollision = FALSE;
		_disposeAnimateAndDeleteEntityOnCollision = FALSE;
		_disposeAndDeleteBeeOnCollision = FALSE;
		_disposeAnimateAndDeleteBeeOnCollision = FALSE;
	}
	return self;
}

-(id) initWithContentsOfDictionary:(NSDictionary *)dict world:(World *)world
{
	if (self = [self init])
	{
		if ([dict objectForKey:@"disposeEntityOnCollision"] != nil)
		{
			_disposeEntityOnCollision = [[dict objectForKey:@"disposeEntityOnCollision"] boolValue];
		}
		if ([dict objectForKey:@"disposeAnimateAndDeleteEntityOnCollision"] != nil)
		{
			_disposeAnimateAndDeleteEntityOnCollision = [[dict objectForKey:@"disposeAnimateAndDeleteEntityOnCollision"] boolValue];
		}
		if ([dict objectForKey:@"disposeAndDeleteBeeOnCollision"] != nil)
		{
			_disposeAndDeleteBeeOnCollision = [[dict objectForKey:@"disposeAndDeleteBeeOnCollision"] boolValue];
		}
		if ([dict objectForKey:@"disposeAnimateAndDeleteBeeOnCollision"] != nil)
		{
			_disposeAnimateAndDeleteBeeOnCollision = [[dict objectForKey:@"disposeAnimateAndDeleteBeeOnCollision"] boolValue];
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
