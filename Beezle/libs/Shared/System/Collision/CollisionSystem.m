//
//  CollisionSystem.m
//  Beezle
//
//  Created by Me on 15/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CollisionSystem.h"
#import "AnythingWithVoidCollisionHandler.h"
#import "Collision.h"
#import "LevelSession.h"

@implementation CollisionSystem

-(id) initWithLevelSession:(LevelSession *)levelSession
{
	if (self = [super init])
	{
		_levelSession = levelSession;
		_handlers = [NSMutableArray new];
	}
	return self;
}

-(id) init
{
    self = [self initWithLevelSession:nil];
    return self;
}

-(void) dealloc
{
	[_handlers release];
	
	[super dealloc];
}

-(void) registerCollisionHandler:(CollisionHandler *)handler
{
	[_handlers addObject:handler];
}

-(BOOL) handleCollision:(Collision *)collision
{	
	BOOL continueProcessingCollision = TRUE;
	for (CollisionHandler *handler in _handlers)
	{
		if (![handler handleCollision:collision])
		{
			continueProcessingCollision = FALSE;
		}
	}
	return continueProcessingCollision;
}

@end
