//
//  CollisionSystem.m
//  Beezle
//
//  Created by Me on 15/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CollisionSystem.h"
#import "AnythingWithVoidCollisionHandler.h"
#import "AnythingWithVolatileCollisionHandler.h"
#import "BeeWithBeeaterCollisionHandler.h"
#import "Collision.h"
#import "ConsumerWithPollenCollisionHandler.h"
#import "DozerWithCrumbleCollisionHandler.h"
#import "LevelSession.h"
#import "SawWithWoodCollisionHandler.h"
#import "SolidWithSoundCollisionHandler.h"
#import "SolidWithBoostCollisionHandler.h"
#import "SolidWithBreakableCollisionHandler.h"
#import "SolidWithWaterCollisionHandler.h"
#import "SolidWithWobbleCollisionHandler.h"

@interface CollisionSystem()

-(void) registerCollisionHandlers;
-(void) registerCollisionHandler:(CollisionHandler *)handler;

@end

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

-(void) initialise
{
	[self registerCollisionHandlers];
}

-(void) registerCollisionHandlers
{
	[self registerCollisionHandler:[AnythingWithVoidCollisionHandler handlerWithWorld:_world levelSession:_levelSession]];
	[self registerCollisionHandler:[AnythingWithVolatileCollisionHandler handlerWithWorld:_world levelSession:_levelSession]];
	[self registerCollisionHandler:[BeeWithBeeaterCollisionHandler handlerWithWorld:_world levelSession:_levelSession]];
	[self registerCollisionHandler:[ConsumerWithPollenCollisionHandler handlerWithWorld:_world levelSession:_levelSession]];
	[self registerCollisionHandler:[DozerWithCrumbleCollisionHandler handlerWithWorld:_world levelSession:_levelSession]];
	[self registerCollisionHandler:[SawWithWoodCollisionHandler handlerWithWorld:_world levelSession:_levelSession]];
	[self registerCollisionHandler:[SolidWithSoundCollisionHandler handlerWithWorld:_world levelSession:_levelSession]];
	[self registerCollisionHandler:[SolidWithBoostCollisionHandler handlerWithWorld:_world levelSession:_levelSession]];
	[self registerCollisionHandler:[SolidWithBreakableCollisionHandler handlerWithWorld:_world levelSession:_levelSession]];
	[self registerCollisionHandler:[SolidWithWaterCollisionHandler handlerWithWorld:_world levelSession:_levelSession]];
	[self registerCollisionHandler:[SolidWithWobbleCollisionHandler handlerWithWorld:_world levelSession:_levelSession]];
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
