//
//  CollisionHandler.h
//  Beezle
//
//  Created by Marcus on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"
#import "cocos2d.h"

@class Collision;

@interface CollisionHandler : NSObject

+(id) handler;

-(void) handleCollision:(Collision *)collision;

@end
