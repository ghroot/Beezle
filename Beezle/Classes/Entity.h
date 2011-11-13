//
//  Actor.h
//  Beezle
//
//  Created by Me on 06/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Component.h"

@class World;
@class EntityManager;

@interface Entity : NSObject
{
    int _entityId;
    World *_world;
    EntityManager *_entityManager;
}

@property (nonatomic) int entityId;

-(id) initWithWorld:(World *)world andId:(int)entityId;
-(void) addComponent:(Component *)component;
-(Component *) getComponent:(Class)componentClass;
-(void) refresh;

@end
