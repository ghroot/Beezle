//
//  Actor.h
//  Beezle
//
//  Created by Me on 06/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AbstractComponent.h"

@class EntityManager;

@interface Entity : NSObject
{
    int _entityId;
    EntityManager *_entityManager;
}

@property (nonatomic) int entityId;

-(id) initWithEntityManage:(EntityManager *)entityManager;
-(void) addComponent:(AbstractComponent *)component;
-(AbstractComponent *) getComponent:(Class)componentClass;

@end
