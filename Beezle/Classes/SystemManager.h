//
//  SystemManager.h
//  Beezle
//
//  Created by Me on 09/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EntitySystem.h"

@class World;

@interface SystemManager : NSObject
{
    World *_world;
    NSMutableArray *_systems;
}

@property (nonatomic, retain) NSMutableArray *systems;

-(id) initWithWorld:(World *)world;
-(EntitySystem *) setSystem:(EntitySystem *)system;
-(EntitySystem *) getSystem:(Class)systemClass;
-(void) initialiseAll;
-(void) processAll;

@end
