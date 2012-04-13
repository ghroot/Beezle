//
//  CollisionHandler.m
//  Beezle
//
//  Created by Marcus on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CollisionHandler.h"

@implementation CollisionHandler

+(id)handler
{
    return [[self new] autorelease];
}

-(BOOL) handleCollision:(Collision *)collision
{
    return TRUE;
}

@end
