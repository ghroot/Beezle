//
//  CollisionSystem.h
//  Beezle
//
//  Created by Me on 15/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EntityProcessingSystem.h"
#import "Collision.h"

@interface CollisionSystem : EntityProcessingSystem
{
    NSMutableArray *_collisions;
}

-(void) pushCollision:(Collision *)collision;

@end
