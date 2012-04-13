//
//  BeeLavaHandler.h
//  Beezle
//
//  Created by KM Lagerstrom on 13/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CollisionHandler.h"

@interface BeeLavaHandler : CollisionHandler
{
    World *_world;
}

+(id) handlerWithWorld:(World *)world;

-(id) initWithWorld:(World *)world;

@end
