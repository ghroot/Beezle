//
//  TagManager.m
//  Beezle
//
//  Created by Me on 10/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TagManager.h"

@implementation TagManager

-(id) init
{
    if (self = [super init])
    {
        _entitiesByTag = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void) registerEntity:(Entity *)entity withTag:(NSString *)tag
{
    [_entitiesByTag setObject:entity forKey:tag];
}

-(Entity *) getEntity:(NSString *)tag
{
    return [_entitiesByTag objectForKey:tag];
}

-(void) dealloc
{
    [_entitiesByTag release];
    
    [super dealloc];
}

@end
