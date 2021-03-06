//
//  LevelSerializer.m
//  Beezle
//
//  Created by Me on 04/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LevelSerializer.h"
#import "EditComponent.h"
#import "EntityUtil.h"
#import "LevelLayout.h"
#import "LevelLayoutEntry.h"

static const int LEVEL_LAYOUT_FORMAT = 2;

@interface LevelSerializer()

-(BOOL) isLevelLayoutEntity:(Entity *)entity;
-(BOOL) hasInstanceComponentDictAnyValues:(NSDictionary *)instanceComponentDict;

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
	int format;
	if ([dict objectForKey:@"format"] != nil)
	{
		format = [[dict objectForKey:@"format"] intValue];
	}
	else
	{
		format = 1;
	}
	NSString *levelName = [dict objectForKey:@"name"];
	
	if (format < LEVEL_LAYOUT_FORMAT)
	{
		NSLog(@"Unsupported level layout format: %@ (format: %d < %d)", levelName, format, LEVEL_LAYOUT_FORMAT);
		return nil;
	}
	
	LevelLayout *levelLayout = [LevelLayout layout];
	
	[levelLayout setFormat:format];
	[levelLayout setLevelName:levelName];
	
	int version = [[dict objectForKey:@"version"] intValue];
	[levelLayout setVersion:version];

	[levelLayout setPollenForTwoFlowers:[[dict objectForKey:@"pollenForTwoFlowers"] intValue]];
	[levelLayout setPollenForThreeFlowers:[[dict objectForKey:@"pollenForThreeFlowers"] intValue]];

	[levelLayout setHasWater:[[dict objectForKey:@"hasWater"] boolValue]];

	NSArray *entities = [dict objectForKey:@"entities"];
	for (NSDictionary *entity in entities) 
	{
		LevelLayoutEntry *levelLayoutEntry = [LevelLayoutEntry entry];
		
		NSString *type = [entity objectForKey:@"type"];
		NSDictionary *instanceComponentsDict = [entity objectForKey:@"components"];

		[levelLayoutEntry setType:[NSString stringWithString:type]];
		[levelLayoutEntry setInstanceComponentsDict:instanceComponentsDict];
		
		[levelLayout addLevelLayoutEntry:levelLayoutEntry];
	}
	
	return levelLayout;
}
 
-(NSDictionary *) dictionaryFromLayout:(LevelLayout *)layout
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	
	[dict setObject:[layout levelName] forKey:@"name"];
	[dict setObject:[NSNumber numberWithInt:[layout version]] forKey:@"version"];
	[dict setObject:[NSNumber numberWithInt:[layout format]] forKey:@"format"];

	[dict setObject:[NSNumber numberWithInt:[layout pollenForTwoFlowers]] forKey:@"pollenForTwoFlowers"];
	[dict setObject:[NSNumber numberWithInt:[layout pollenForThreeFlowers]] forKey:@"pollenForThreeFlowers"];

	[dict setObject:[NSNumber numberWithBool:[layout hasWater]] forKey:@"hasWater"];
	
	NSMutableArray *entities = [NSMutableArray array];
	for (LevelLayoutEntry *levelLayoutEntry in [layout entries])
	{
		NSMutableDictionary *entity = [NSMutableDictionary dictionary];
		[entity setObject:[levelLayoutEntry type] forKey:@"type"];
		[entity setObject:[levelLayoutEntry instanceComponentsDict] forKey:@"components"];
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
    [levelLayout setFormat:LEVEL_LAYOUT_FORMAT];
	
	[levelLayout setHasWater:[EntityUtil hasWaterEntity:world]];
	
	for (Entity *entity in [[world entityManager] entities])
	{
		if ([self isLevelLayoutEntity:entity])
		{
			LevelLayoutEntry *levelLayoutEntry = [[[LevelLayoutEntry alloc] init] autorelease];
			
			EditComponent *editComponent = [EditComponent getFrom:entity];
			[levelLayoutEntry setType:[editComponent levelLayoutType]];
			
			NSMutableDictionary *instanceComponentsDict = [NSMutableDictionary dictionary];
			NSArray *components = [entity getComponents];
			for (Component *component in components)
			{
				NSDictionary *instanceComponentDict = [component getInstanceComponentDict];
				if ([self hasInstanceComponentDictAnyValues:instanceComponentDict])
				{
                    NSString *componentClassName = NSStringFromClass([component class]);
                    NSString *componentName = [[componentClassName stringByReplacingOccurrencesOfString:@"Component" withString:@""] lowercaseString];
					[instanceComponentsDict setObject:instanceComponentDict forKey:componentName];
				}
			}
			[levelLayoutEntry setInstanceComponentsDict:instanceComponentsDict];
						
			[levelLayout addLevelLayoutEntry:levelLayoutEntry];
		}
	}
	
	return levelLayout;
}

-(BOOL) isLevelLayoutEntity:(Entity *)entity
{
	if ([entity hasComponent:[EditComponent class]])
	{
		EditComponent *editComponent = (EditComponent *)[entity getComponent:[EditComponent class]];
		if ([editComponent levelLayoutType] != nil)
		{
			return TRUE;
		}
	}
	return FALSE;
}

-(BOOL) hasInstanceComponentDictAnyValues:(NSDictionary *)instanceComponentDict
{
    // TODO: Check all sub collections
    return instanceComponentDict != nil &&
        [instanceComponentDict count] > 0;
}

@end
