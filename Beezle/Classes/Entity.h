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
    
    BOOL _deleted;
}

@property (nonatomic) int entityId;
@property (nonatomic, readonly) World *world;
@property (nonatomic) BOOL deleted;

-(id) initWithWorld:(World *)world andId:(int)entityId;
-(void) addComponent:(Component *)component;
-(Component *) getComponent:(Class)componentClass;
-(void) refresh;
-(void) deleteEntity;
-(void) setTag:(NSString *)tag;

@end
