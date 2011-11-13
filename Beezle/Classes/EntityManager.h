//
//  EntityManager.h
//  Beezle
//
//  Created by Me on 08/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Entity.h"
#import "Component.h"

@class World;

@interface EntityManager : NSObject
{
    World *_world;
    int _nextEntityId;
    NSMutableArray *_entities;
    NSMutableDictionary *_componentsByClass;
}

-(id) initWithWorld:(World *)world;
-(Entity *) createEntity;
-(void) remove:(Entity *)entity;
-(void) removeComponentsOfEntity:(Entity *)entity;
-(void) addComponent:(Component *)component toEntity:(Entity *)entity;
-(void) refresh:(Entity *)entity;
-(void) removeComponent:(Component *)component fromEntity:(Entity *)entity;
-(void) removeComponentWithClass:(Class)componentClass fromEntity:(Entity *)entity;
-(Component *) getComponentWithClass:(Class)componentClass fromEntity:(Entity *)entity;
-(Entity *) getEntity:(int)entityId;
-(NSArray *) getComponents:(Entity *)entity;

@end
