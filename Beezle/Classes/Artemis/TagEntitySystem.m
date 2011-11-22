//
//  TagEntitySystem.m
//  Beezle
//
//  Created by Me on 21/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TagEntitySystem.h"
#import "TagManager.h"
#import "World.h"

@implementation TagEntitySystem

-(id) initWithUsedComponentClasses:(NSArray *)usedComponentClasses andTag:(NSString *)tag;
{
    if (self = [super initWithUsedComponentClasses:usedComponentClasses])
    {
        _tag = [tag retain];
    }
    return self;
}

-(void) dealloc
{
    [_tag release];
    
    [super dealloc];
}

-(void) processEntities:(NSArray *)entities
{
    Entity *taggedEntity = [[_world tagManager] getEntity:_tag];
    [self processTaggedEntity:taggedEntity];
}

-(void) processTaggedEntity:(Entity *)entity
{
}

@end
