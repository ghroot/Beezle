//
//  CollisionHandler.h
//  Beezle
//
//  Created by Me on 11/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CollisionTypes.h"

@interface CollisionHandler : NSObject
{
	CollisionType _type1;
	CollisionType _type2;
	SEL _selector;
}

@property (nonatomic, readonly) CollisionType type1;
@property (nonatomic, readonly) CollisionType type2;
@property (nonatomic, readonly) SEL selector;

+(CollisionHandler *) handlerWithType1:(CollisionType)type1 type2:(CollisionType)type2 selector:(SEL)selector;

-(id) initWithType1:(CollisionType)type1 type2:(CollisionType)type2 selector:(SEL)selector;

@end
