//
//  GroupManager.m
//  Beezle
//
//  Created by Me on 21/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GroupManager.h"

@implementation GroupManager

-(id) init
{
    if (self = [super init])
    {
        _entitiesByGroupName = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void) dealloc
{
    [_entitiesByGroupName release];
    
    [super dealloc];
}

-(void) addEntity:(Entity *)entity toGroup:(NSString *)groupName
{
    NSMutableArray *entitiesInGroup;
    if ([_entitiesByGroupName objectForKey:groupName] == nil)
    {
        entitiesInGroup = [[[NSMutableArray alloc] init] autorelease];
        [_entitiesByGroupName setObject:entitiesInGroup forKey:groupName];
    }
    else
    {
        entitiesInGroup = [_entitiesByGroupName objectForKey:groupName];
    }
    [entitiesInGroup addObject:entity];
}

-(NSArray *) getEntitiesInGroup:(NSString *)groupName
{
    if ([_entitiesByGroupName objectForKey:groupName] != nil)
    {
        NSArray *entitiesInGroup = [_entitiesByGroupName objectForKey:groupName];
        return entitiesInGroup;
    }
    else
    {
        // Return empty array
        return [NSArray array];
    }
}

-(void) removeEntity:(Entity *)entity fromGroup:(NSString *)groupName
{
    if ([_entitiesByGroupName objectForKey:groupName] != nil)
    {
        NSMutableArray *entitiesInGroup = [_entitiesByGroupName objectForKey:groupName];
        if ([entitiesInGroup containsObject:entity])
        {
            [entitiesInGroup removeObject:entity];
        }
    }
}

@end
