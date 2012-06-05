//
//  StringCollection.m
//  Beezle
//
//  Created by Marcus on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StringCollection.h"

@implementation StringCollection

@synthesize strings = _strings;

-(id) initFromDictionary:(NSDictionary *)dict baseName:(NSString *)baseName
{
    if (self = [self init])
    {
        [self addStringsFromDictionary:dict baseName:baseName];
    }
    return self;
}

-(id) init
{
    if (self = [super init])
    {
        _strings = [NSMutableArray new];
    }
    return self;
}

-(void) dealloc
{
    [_strings release];
    
    [super dealloc];
}

-(void) addStringsFromDictionary:(NSDictionary *)dict baseName:(NSString *)baseName
{
    if ([dict objectForKey:baseName] != nil &&
		[[dict objectForKey:baseName] length] > 0)
	{
        [self addString:[dict objectForKey:baseName]];
    }
    
    NSString *pluralName = [baseName stringByAppendingString:@"s"];
    if ([dict objectForKey:pluralName] != nil)
    {
        for (NSString *string in [dict objectForKey:pluralName])
        {
			if ([string length] > 0)
			{
            	[self addString:string];
			}
        }
    }
}

-(void) addString:(NSString *)string
{
    [_strings addObject:string];
}

-(BOOL) hasStrings
{
    return [_strings count] > 0;
}

-(NSString *) randomString
{
    if ([_strings count] > 0)
    {
        int randomIndex = rand() % [_strings count];
        return [_strings objectAtIndex:randomIndex];
    }
    else
    {
        return nil;
    }
}

@end
