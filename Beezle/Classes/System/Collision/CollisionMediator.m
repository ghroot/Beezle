//
//  CollisionHandler.m
//  Beezle
//
//  Created by Me on 11/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CollisionMediator.h"
#import "Collision.h"
#import "CollisionHandler.h"
#import "CollisionType.h"

@implementation CollisionMediator

+(CollisionMediator *) mediatorWithType1:(CollisionType *)type1 type2:(CollisionType *)type2 handler:(CollisionHandler *)handler
{
	return [[[self alloc] initWithType1:type1 type2:type2 handler:handler] autorelease];
}

-(id) initWithType1:(CollisionType *)type1 type2:(CollisionType *)type2 handler:(CollisionHandler *)handler
{
	if (self = [super init])
	{
		_type1 = type1;
		_type2 = type2;
        _handler = [handler retain];
	}
	return self;
}

-(void) dealloc
{
    [_handler release];
    
    [super dealloc];
}

-(BOOL) appliesForCollision:(Collision *)collision
{
    return _type1 == [collision firstCollisionType] && 
        _type2 == [collision secondCollisionType];
}

-(BOOL) mediateCollision:(Collision *)collision
{
    return [_handler handleCollision:collision];
}

@end
