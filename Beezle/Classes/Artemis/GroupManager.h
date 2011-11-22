//
//  GroupManager.h
//  Beezle
//
//  Created by Me on 21/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

@class Entity;

@interface GroupManager : NSObject
{
    NSMutableDictionary *_entitiesByGroupName;
}

-(void) addEntity:(Entity *)entity toGroup:(NSString *)groupName;
-(NSArray *) getEntitiesInGroup:(NSString *)groupName;
-(void) removeEntity:(Entity *)entity fromGroup:(NSString *)groupName;

@end
