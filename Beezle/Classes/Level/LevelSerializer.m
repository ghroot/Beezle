//
//  LevelSerializer.m
//  Beezle
//
//  Created by Me on 04/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LevelSerializer.h"
#import "BeeaterComponent.h"
#import "EditComponent.h"
#import "LevelLayout.h"
#import "LevelLayoutCache.h"
#import "LevelLayoutEntry.h"
#import "SlingerComponent.h"
#import "TransformComponent.h"

@interface LevelSerializer()

-(CGPoint) stringToPosition:(NSString *)string;

@end

@implementation LevelSerializer

+(LevelSerializer *) sharedSerializer
{
    static LevelSerializer *serializer = 0;
    if (!serializer)
    {
        serializer = [[self alloc] init];
    }
    return serializer;
}

-(LevelLayout *) layoutFromDictionary:(NSDictionary *)dict
{
	LevelLayout *levelLayout = [LevelLayout layout];
	
	NSString *levelName = [dict objectForKey:@"name"];
	[levelLayout setLevelName:levelName];
	
	int version = [[dict objectForKey:@"version"] intValue];
	[levelLayout setVersion:version];
	
	NSArray *entities = [dict objectForKey:@"entities"];
	for (NSDictionary *entity in entities) 
	{
		LevelLayoutEntry *levelLayoutEntry = [LevelLayoutEntry entry];
		
		NSString *type = [entity objectForKey:@"type"];
		[levelLayoutEntry setType:[NSString stringWithString:type]];
		
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
				[levelLayoutEntry addBeeTypeAsString:[NSString stringWithString:beeTypeAsString]];
			}
		}
		else if ([type isEqualToString:@"BEEATER"])
		{
			NSString *beeTypeAsString = [entity objectForKey:@"bee"];
			[levelLayoutEntry setBeeTypeAsString:[NSString stringWithString:beeTypeAsString]];
		}
		
		[levelLayout addLevelLayoutEntry:levelLayoutEntry];
	}
	
	return levelLayout;
}
 
-(NSDictionary *) dictionaryFromLayout:(LevelLayout *)layout
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	
	[dict setObject:[layout levelName] forKey:@"name"];
	[dict setObject:[NSNumber numberWithInt:[layout version]] forKey:@"version"];
	
	NSMutableArray *entities = [NSMutableArray array];
	for (LevelLayoutEntry *levelLayoutEntry in [layout entries])
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
	[dict setObject:entities forKey:@"entities"];
	
	return dict;
}

-(LevelLayout *) layoutFromWorld:(World *)world levelName:(NSString *)levelName version:(int)version
{
	LevelLayout *levelLayout = [LevelLayout layout];
	
	[levelLayout setLevelName:levelName];
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
	
	return levelLayout;
}

-(CGPoint) stringToPosition:(NSString *)string
{
    NSString *modifiedString = string;
    modifiedString = [modifiedString stringByReplacingOccurrencesOfString:@"{ " withString:@""];
    modifiedString = [modifiedString stringByReplacingOccurrencesOfString:@" }" withString:@""];
    NSArray *array = [modifiedString componentsSeparatedByString:@","];
    return CGPointMake([[array objectAtIndex:0] floatValue], [[array objectAtIndex:1] floatValue]);
}

@end
