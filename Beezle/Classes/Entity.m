//
//  Actor.m
//  Beezle
//
//  Created by Me on 06/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Entity.h"

#import "EntityManager.h"

@implementation Entity

@synthesize entityId = _entityId;

-(id) initWithEntityManage:(EntityManager *)entityManager
{
    if (self = [super init])
    {
        _entityManager = entityManager;
    }
    return self;
}

-(void) addComponent:(AbstractComponent *)component
{
    [_entityManager addComponent:component toEntity:self];
}

-(AbstractComponent *) getComponent:(Class)componentClass;
{
    return [_entityManager getComponent:componentClass fromEntity:self];
}

@end
