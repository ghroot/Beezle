//
//  WaterDropHandler.h
//  Beezle
//
//  Created by Marcus on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CollisionHandler.h"

@interface WaterDropHandler : CollisionHandler
{
    World *_world;
}

+(id) handlerWithWorld:(World *)world;

-(id) initWithWorld:(World *)world;

@end
