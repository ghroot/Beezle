//
//  CollisionHandler.h
//  Beezle
//
//  Created by Me on 11/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "chipmunk.h"

@interface CollisionMediator : NSObject
{
	cpCollisionType _type1;
	cpCollisionType _type2;
	SEL _selector;
}

@property (nonatomic, readonly) cpCollisionType type1;
@property (nonatomic, readonly) cpCollisionType type2;
@property (nonatomic, readonly) SEL selector;

+(CollisionMediator *) mediatorWithType1:(cpCollisionType)type1 type2:(cpCollisionType)type2 selector:(SEL)selector;

-(id) initWithType1:(cpCollisionType)type1 type2:(cpCollisionType)type2 selector:(SEL)selector;

@end
