//
//  ComponentDirectory.m
//  Beezle
//
//  Created by Marcus on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ComponentDirectory.h"

@implementation ComponentDirectory

+(ComponentDirectory *) sharedDirectory
{
    static ComponentDirectory *directory = 0;
    if (!directory)
    {
        directory = [[self alloc] init];
    }
    return directory;
}

-(id) init
{
    if (self = [super init])
    {
        _componentClassesByName = [NSMutableDictionary new];
    }
    return self;
}

-(void) dealloc
{
    [_componentClassesByName release];
    
    [super dealloc];
}

-(void) registerComponentClass:(Class)componentClass forName:(NSString *)name
{
    [_componentClassesByName setObject:componentClass forKey:name];
}

-(Class) componentClassForName:(NSString *)name
{
    return [_componentClassesByName objectForKey:name];
}

@end
