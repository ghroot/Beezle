//
//  CollisionHandler.h
//  Beezle
//
//  Created by Me on 11/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ObjectiveChipmunk.h"
#import "artemis.h"

@class Collision;
@class CollisionHandler;
@class CollisionType;

@interface CollisionMediator : NSObject
{
	CollisionType *_type1;
	CollisionType *_type2;
    CollisionHandler *_handler;
}


+(CollisionMediator *) mediatorWithType1:(CollisionType *)type1 type2:(CollisionType *)type2 handler:(CollisionHandler *)handler;

-(id) initWithType1:(CollisionType *)type1 type2:(CollisionType *)type2 handler:(CollisionHandler *)handler;

-(BOOL) appliesForCollision:(Collision *)collision;
-(BOOL) mediateCollision:(Collision *)collision;

@end
