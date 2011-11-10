//
//  EntityProcessingSystem.m
//  Beezle
//
//  Created by Me on 10/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EntityProcessingSystem.h"

@implementation EntityProcessingSystem

-(id) initWithUsedComponentClasses:(NSMutableArray *)usedComponentClasses
{
    self = [super initWithUsedComponentClasses:usedComponentClasses];
    return self;
}

-(void) processEntity:(Entity *)entity
{
}

-(void) processEntities:(NSArray *)entities
{
    for (Entity *entity in entities)
    {
        [self processEntity:entity];
    }
}

@end
