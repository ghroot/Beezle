//
//  CollisionHandler.h
//  Beezle
//
//  Created by Me on 11/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ObjectiveChipmunk.h"
#import "artemis.h"
#import "Collision.h"
#import "CollisionType.h"

@interface CollisionMediator : NSObject
{
	CollisionType *_type1;
	CollisionType *_type2;
    id _target;
	SEL _selector;
}

+(CollisionMediator *) mediatorWithType1:(CollisionType *)type1 type2:(CollisionType *)type2 target:(id)target selector:(SEL)selector;

-(id) initWithType1:(CollisionType *)type1 type2:(CollisionType *)type2 target:(id)target selector:(SEL)selector;

-(BOOL) appliesForCollision:(Collision *)collision;
-(void) mediateCollision:(Collision *)collision;

@end
