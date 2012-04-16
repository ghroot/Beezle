//
//  CollisionHandler.m
//  Beezle
//
//  Created by Marcus on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CollisionHandler.h"
#import "LevelSession.h"

@implementation CollisionHandler

@synthesize firstCollisionType = _firstCollisionType;
@synthesize secondCollisionTypes = _secondCollisionTypes;

+(id) handlerWithWorld:(World *)world andLevelSession:(LevelSession *)levelSession
{
	return [[[self alloc] initWithWorld:world andLevelSession:levelSession] autorelease];
}

-(id) initWithWorld:(World *)world andLevelSession:(LevelSession *)levelSession
{
	if (self = [super init])
    {
		_world = world;
        _levelSession = levelSession;
        
        _secondCollisionTypes = [NSMutableArray new];
    }
    return self;
}

-(void) dealloc
{
    [_secondCollisionTypes release];
    
    [super dealloc];
}

-(BOOL) handleCollision:(Collision *)collision
{
    return TRUE;
}

@end
