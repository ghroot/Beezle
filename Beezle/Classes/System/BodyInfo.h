//
//  BodyInfo.h
//  Beezle
//
//  Created by Me on 03/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "chipmunk.h"

@class PhysicsBody;
@class PhysicsShape;

@interface BodyInfo : NSObject
{
    PhysicsBody *_physicsBody;
    NSMutableArray *_physicsShapes;
}

@property (nonatomic, readonly) PhysicsBody *physicsBody;
@property (nonatomic, readonly) NSArray *physicsShapes;

-(void) setBody:(cpBody *)body;
-(void) addShape:(cpShape *)shape;

@end
