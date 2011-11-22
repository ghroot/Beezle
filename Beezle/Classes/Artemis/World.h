//
//  World.h
//  Beezle
//
//  Created by Me on 09/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

@class Entity;
@class EntityManager;
@class GroupManager;
@class SystemManager;
@class TagManager;

@interface World : NSObject
{
    EntityManager *_entityManager;
    SystemManager *_systemManager;
    TagManager *_tagManager;
    GroupManager *_groupManager;
    
    int _delta;
    
    NSMutableArray *_refreshed;
    NSMutableArray *_deleted;
}

@property (nonatomic, readonly) EntityManager *entityManager;
@property (nonatomic, readonly) SystemManager *systemManager;
@property (nonatomic, readonly) TagManager *tagManager;
@property (nonatomic, readonly) GroupManager *groupManager;
@property (nonatomic) int delta;

-(void) deleteEntity:(Entity *)entity;
-(void) refreshEntity:(Entity *)entity;
-(Entity *) createEntity;
-(Entity *) getEntity:(int) entityId;
-(void) loopStart;

@end
