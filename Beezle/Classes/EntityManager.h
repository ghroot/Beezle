//
//  EntityManager.h
//  Beezle
//
//  Created by Me on 08/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Entity.h"
#import "AbstractComponent.h"

@interface EntityManager : NSObject
{
    int _nextEntityId;
    NSMutableArray *_entities;
    NSMutableDictionary *_componentsByClass;
}

-(Entity *) createEntity;
-(void) addComponent:(AbstractComponent *)component toEntity:(Entity *)entity;
-(AbstractComponent *) getComponent:(Class)componentClass fromEntity:(Entity *)entity;

@end
