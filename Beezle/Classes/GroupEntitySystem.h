//
//  GroupEntitySystem.h
//  Beezle
//
//  Created by Me on 21/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EntitySystem.h"

@class Entity;

@interface GroupEntitySystem : EntitySystem
{
    NSString *_groupName;
}

-(id) initWithGroup:(NSString *)groupName;
-(void) processEntitiesInGroup:(NSArray *)entities;

@end
