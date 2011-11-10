//
//  EntityManager.h
//  Beezle
//
//  Created by Me on 08/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Entity.h"
#import "AbstractComponent.h"

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
-(void) addComponent:(AbstractComponent *)component toEntity:(Entity *)entity;
-(void) refresh:(Entity *)entity;
-(void) removeComponent:(AbstractComponent *)component fromEntity:(Entity *)entity;
-(void) removeComponentWithClass:(Class)componentClass fromEntity:(Entity *)entity;
-(AbstractComponent *) getComponentWithClass:(Class)componentClass fromEntity:(Entity *)entity;
-(Entity *) getEntity:(int)entityId;
-(NSArray *) getComponents:(Entity *)entity;

@end
