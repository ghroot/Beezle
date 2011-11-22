//
//  PhysicsShape.h
//  Beezle
//
//  Created by Me on 22/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "chipmunk.h"

@interface PhysicsShape : NSObject
{
    cpShape *_shape;
}

@property (nonatomic, readonly) cpShape *shape;

-(id) initWithShape:(cpShape *)shape;

@end
