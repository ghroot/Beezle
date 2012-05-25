//
//  CollisionHandler.h
//  Beezle
//
//  Created by KM Lagerstrom on 22/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

@class Collision;
@class LevelSession;

@interface CollisionHandler : NSObject
{
	World *_world;
	LevelSession *_levelSession;
	NSMutableArray *_firstComponentClasses;
	NSMutableArray *_secondComponentClasses;
}

+(id) handlerWithWorld:(World *)world levelSession:(LevelSession *)levelSession;

-(id) initWithWorld:(World *)world levelSession:(LevelSession *)levelSession;

-(BOOL) handleCollision:(Collision *)collision;
-(BOOL) handleCollisionBetween:(Entity *)firstEntity and:(Entity *)secondEntity collision:(Collision *)collision;

@end
