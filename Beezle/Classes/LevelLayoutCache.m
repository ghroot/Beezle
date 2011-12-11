//
//  LevelLayoutCache.m
//  Beezle
//
//  Created by Me on 03/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "LevelLayoutCache.h"
#import "LevelLayout.h"
#import "LevelLayoutEntry.h"

static LevelLayoutCache *sharedLevelLayoutCache;

@interface LevelLayoutCache()

-(CGPoint) stringToPosition:(NSString *)str;

@end

@implementation LevelLayoutCache

-(id) init
{
    if (self = [super init])
    {
        _levelLayoutsByName = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void) dealloc
{
    [_levelLayoutsByName release];
    
    [super dealloc];
}

+(LevelLayoutCache *) sharedLevelLayoutCache
{
    if(!sharedLevelLayoutCache)
    {
        sharedLevelLayoutCache = [[LevelLayoutCache alloc] init];
    }
    return sharedLevelLayoutCache;
}

-(void) addLevelLayoutsWithDictionary:(NSDictionary *)dict
{
    NSDictionary *levels = [dict objectForKey:@"levels"];
    for (NSString *levelName in [levels allKeys])
    {
        LevelLayout *levelLayout = [[[LevelLayout alloc] init] autorelease];
        
        NSDictionary *level = [levels objectForKey:levelName];
        NSArray *entities = [level objectForKey:@"entities"];
        for (NSDictionary *entity in entities) 
        {
            LevelLayoutEntry *levelLayoutEntry = [[[LevelLayoutEntry alloc] init] autorelease];
            
            NSString *type = [entity objectForKey:@"type"];
            [levelLayoutEntry setType:type];
            
            CGPoint position = [self stringToPosition:[entity objectForKey:@"position"]];
            [levelLayoutEntry setPosition:position];
            
            BOOL mirrored = [[entity objectForKey:@"mirrored"] boolValue];
            [levelLayoutEntry setMirrored:mirrored];
            
            int rotation = [[entity objectForKey:@"rotation"] intValue];
            [levelLayoutEntry setRotation:rotation];
            
            if ([type isEqualToString:@"SLINGER"])
            {
                NSArray *beeTypesAsStrings = [entity objectForKey:@"bees"];
                for (NSString *beeTypeAsString in beeTypesAsStrings)
                {
                    [levelLayoutEntry addBeeTypeAsString:beeTypeAsString];
                }
            }
            else if ([type isEqualToString:@"BEEATER"])
            {
                NSString *beeTypeAsString = [entity objectForKey:@"bee"];
                [levelLayoutEntry setBeeTypeAsString:beeTypeAsString];
            }
            
//            NSLog(@"%@   %f,%f   %@   %i", type, position.x, position.y, (mirrored ? @"YES" : @"NO"), rotation);
            
            [levelLayout addLevelLayoutEntry:levelLayoutEntry];
        }
        
        [_levelLayoutsByName setObject:levelLayout forKey:levelName];
    }
}

-(void) addLevelLayoutsWithFile:(NSString *)fileName
{
    NSString *path = [CCFileUtils fullPathFromRelativePath:fileName];
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    
	[self addLevelLayoutsWithDictionary:dict];
}

-(CGPoint) stringToPosition:(NSString *)str
{
    NSString* theString = str;
    theString = [theString stringByReplacingOccurrencesOfString:@"{ " withString:@""];
    theString = [theString stringByReplacingOccurrencesOfString:@" }" withString:@""];
    NSArray *array = [theString componentsSeparatedByString:@","];
    return CGPointMake([[array objectAtIndex:0] floatValue], [[array objectAtIndex:1] floatValue]);
}

-(LevelLayout *) levelLayoutByName:(NSString *)levelName
{
    return [_levelLayoutsByName objectForKey:levelName];
}

@end
