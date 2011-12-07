//
//  PhysicsBody.h
//  Beezle
//
//  Created by Me on 22/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "chipmunk.h"

@interface PhysicsBody : NSObject
{
    cpBody *_body;
}

@property (nonatomic, readonly) cpBody *body;

+(id) physicsBodyWithBody:(cpBody *)body;

-(id) initWithBody:(cpBody *)body;

@end
