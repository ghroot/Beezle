//
//  GroupEntitySystem.m
//  Beezle
//
//  Created by Me on 21/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GroupEntitySystem.h"
#import "GroupManager.h"
#import "World.h"

@implementation GroupEntitySystem

-(id) initWithGroup:(NSString *)groupName
{
    if (self = [super init])
    {
        _groupName = [groupName retain];
    }
    return self;
}

-(void) dealloc
{
    [_groupName release];
    
    [super dealloc];
}

-(void) processEntities:(NSArray *)entities
{
    NSArray *entitiesInGroup = [[_world groupManager] getEntitiesInGroup:_groupName];
    [self processEntitiesInGroup:entitiesInGroup];
}

-(void) processEntitiesInGroup:(NSArray *)entities
{
}

@end
