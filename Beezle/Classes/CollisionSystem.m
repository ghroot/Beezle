//
//  CollisionSystem.m
//  Beezle
//
//  Created by Me on 15/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CollisionSystem.h"

#import "Entity.h"

@implementation CollisionSystem

-(id) init
{
    if (self = [super init])
    {
        _collisions = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void) pushCollision:(Collision *)collision
{
    [_collisions addObject:collision];
}

-(void) begin
{
    for (Collision *collision in _collisions)
    {
        [[collision secondEntity] deleteEntity];
    }
    [_collisions removeAllObjects];
}

-(void) dealloc
{
    [_collisions release];
    
    [super dealloc];
}

@end
