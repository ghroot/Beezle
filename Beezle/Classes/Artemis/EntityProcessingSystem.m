//
//  EntityProcessingSystem.m
//  Beezle
//
//  Created by Me on 10/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EntityProcessingSystem.h"
#import "Entity.h"

@implementation EntityProcessingSystem

-(void) processEntities:(NSArray *)entities
{
    for (Entity *entity in entities)
    {
        [self processEntity:entity];
    }
}

-(void) processEntity:(Entity *)entity
{
}

@end
