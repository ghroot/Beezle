//
//  CollisionSystem.h
//  Beezle
//
//  Created by Me on 15/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EntitySystem.h"
#import "artemis.h"
#import "cocos2d.h"

@class Collision;
@class GameRulesSystem;

@interface CollisionSystem : EntitySystem
{
	GameRulesSystem *_gameRulesSystem;
	
	NSMutableArray *_collisionMediators;
    NSMutableArray *_collisions;
	
	Collision *_currentCollision;
}

-(void) pushCollision:(Collision *)collision;

@end
