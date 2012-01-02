//
//  LevelLayoutCache.m
//  Beezle
//
//  Created by Me on 03/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "LevelLayoutCache.h"
#import "BeeaterComponent.h"
#import "BeeTypes.h"
#import "EditComponent.h"
#import "LevelLayout.h"
#import "LevelLayoutEntry.h"
#import "SlingerComponent.h"
#import "TransformComponent.h"

static LevelLayoutCache *sharedLevelLayoutCache;

@interface LevelLayoutCache()

-(CGPoint) stringToPosition:(NSString *)string;

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
    if (!sharedLevelLayoutCache)
    {
        sharedLevelLayoutCache = [[LevelLayoutCache alloc] init];
    }
    return sharedLevelLayoutCache;
}

-(void) addLevelLayout:(LevelLayout *)levelLayout
{
	[_levelLayoutsByName setObject:levelLayout forKey:[levelLayout levelName]];
}

-(void) addLevelLayoutsWithDictionary:(NSDictionary *)dict
{
    NSDictionary *levels = [dict objectForKey:@"levels"];
    for (NSString *levelName in [levels allKeys])
    {
        LevelLayout *levelLayout = [[[LevelLayout alloc] initWithLevelName:levelName] autorelease];
        
        NSDictionary *level = [levels objectForKey:levelName];
		
		int version = [[level objectForKey:@"version"] intValue];
		[levelLayout setVersion:version];
		
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
            
            [levelLayout addLevelLayoutEntry:levelLayoutEntry];
        }
        
		[self addLevelLayout:levelLayout];
    }
}

-(void) addLevelLayoutsWithFile:(NSString *)fileName
{
    NSString *path = [CCFileUtils fullPathFromRelativePath:fileName];
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    
	[self addLevelLayoutsWithDictionary:dict];
}

-(CGPoint) stringToPosition:(NSString *)string
{
    NSString *modifiedString = string;
    modifiedString = [modifiedString stringByReplacingOccurrencesOfString:@"{ " withString:@""];
    modifiedString = [modifiedString stringByReplacingOccurrencesOfString:@" }" withString:@""];
    NSArray *array = [modifiedString componentsSeparatedByString:@","];
    return CGPointMake([[array objectAtIndex:0] floatValue], [[array objectAtIndex:1] floatValue]);
}

-(void) addLevelLayoutWithWorld:(World *)world levelName:(NSString *)levelName version:(int)version
{
	LevelLayout *levelLayout = [[[LevelLayout alloc] initWithLevelName:levelName] autorelease];
	
	[levelLayout setVersion:version];
	
	for (Entity *entity in [[world entityManager] entities])
	{
		if ([entity hasComponent:[EditComponent class]])
		{
			LevelLayoutEntry *levelLayoutEntry = [[[LevelLayoutEntry alloc] init] autorelease];
			
			EditComponent *editComponent = (EditComponent *)[entity getComponent:[EditComponent class]];
			TransformComponent *transformComponent = (TransformComponent *)[entity getComponent:[TransformComponent class]];
			
			[levelLayoutEntry setType:[editComponent levelLayoutType]];
			[levelLayoutEntry setPosition:[transformComponent position]];
			[levelLayoutEntry setMirrored:[transformComponent scale].x == -1];
			[levelLayoutEntry setRotation:[transformComponent rotation]];
			
			if ([[editComponent levelLayoutType] isEqualToString:@"SLINGER"])
			{
				SlingerComponent *slingerComponent = (SlingerComponent *)[entity getComponent:[SlingerComponent class]];
				for (BeeTypes *beeType in [slingerComponent queuedBeeTypes])
				{
					[levelLayoutEntry addBeeTypeAsString:[beeType string]];
				}
			}
			else if ([[editComponent levelLayoutType] isEqualToString:@"BEEATER"])
			{
				BeeaterComponent *beeaterComponent = (BeeaterComponent *)[entity getComponent:[BeeaterComponent class]];
				[levelLayoutEntry setBeeTypeAsString:[[beeaterComponent containedBeeType] string]];
			}
			
			[levelLayout addLevelLayoutEntry:levelLayoutEntry];
		}
	}
	
	[self addLevelLayout:levelLayout];
}

-(LevelLayout *) levelLayoutByName:(NSString *)levelName
{
    return [_levelLayoutsByName objectForKey:levelName];
}

-(NSDictionary *) levelLayoutAsDictinaryByName:(NSString *)name
{
	LevelLayout *levelLayout = [self levelLayoutByName:name];
	
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	
	NSMutableDictionary *levels = [NSMutableDictionary dictionary];
	[dict setObject:levels forKey:@"levels"];
	
	NSMutableDictionary *level = [NSMutableDictionary dictionary];
	[levels setObject:level forKey:[levelLayout levelName]];
	[level setObject:[NSNumber numberWithInt:[levelLayout version]] forKey:@"version"];
	
	NSMutableArray *entities = [NSMutableArray array];
	for (LevelLayoutEntry *levelLayoutEntry in [levelLayout entries])
	{
		NSMutableDictionary *entity = [NSMutableDictionary dictionary];
		
		[entity setObject:[levelLayoutEntry type] forKey:@"type"];
		[entity setObject:[NSString stringWithFormat:@"{ %.2f, %.2f }", [levelLayoutEntry position].x, [levelLayoutEntry position].y] forKey:@"position"];
		[entity setObject:[NSNumber numberWithBool:[levelLayoutEntry mirrored]] forKey:@"mirrored"];
		[entity setObject:[NSNumber numberWithInt:[levelLayoutEntry rotation]] forKey:@"rotation"];
		
		if ([[levelLayoutEntry type] isEqualToString:@"SLINGER"])
		{
			NSMutableArray *bees = [NSMutableArray arrayWithArray:[levelLayoutEntry beeTypesAsStrings]];
			[entity setObject:bees forKey:@"bees"];
		}
		else if ([[levelLayoutEntry type] isEqualToString:@"BEEATER"])
		{
			[entity setObject:[levelLayoutEntry beeTypeAsString] forKey:@"bee"];
		}
		
		[entities addObject:entity];
	}
	[level setObject:entities forKey:@"entities"];
	
	return dict;
}

-(void) purgeAllCachedLevelLayouts
{
	[_levelLayoutsByName removeAllObjects];
}

-(void) purgeCachedLevelLayout:(NSString *)levelName
{
	[_levelLayoutsByName removeObjectForKey:levelName];
}

@end
