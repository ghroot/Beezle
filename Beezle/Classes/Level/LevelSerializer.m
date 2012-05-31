//
//  LevelSerializer.m
//  Beezle
//
//  Created by Me on 04/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LevelSerializer.h"
#import "BeeType.h"
#import "EditComponent.h"
#import "EntityUtil.h"
#import "LevelLayout.h"
#import "LevelLayoutEntry.h"
#import "LevelOrganizer.h"

#define LEVEL_LAYOUT_FORMAT 2

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
	
	[levelLayout setHasWater:[[dict objectForKey:@"hasWater"] boolValue]];
	
	NSArray *entities = [dict objectForKey:@"entities"];
	for (NSDictionary *entity in entities) 
	{
		LevelLayoutEntry *levelLayoutEntry = [LevelLayoutEntry entry];
		
		NSString *type = [entity objectForKey:@"type"];
		NSDictionary *instanceComponentsDict = [entity objectForKey:@"components"];
		
		// TEMP: Convert from old to new entity types
		if ([type isEqualToString:@"POLLEN"])
		{
			type = @"POLLEN-YELLOW";
		}
		else if ([type isEqualToString:@"RAMP"])
		{
			NSString *theme = [[LevelOrganizer sharedOrganizer] themeForLevel:levelName];
			type = [NSString stringWithFormat:@"RAMP-%@", theme];
		}
		else if ([type hasPrefix:@"GLASS-"] &&
				 [type length] >= 8)
		{
			NSString *glassBaseName;
			NSString *levelSuffix = [[levelName componentsSeparatedByString:@"-"] objectAtIndex:1];
			NSArray *typeComponents = [type componentsSeparatedByString:@"-"];
			if ([typeComponents count] == 3)
			{
				int glassNumber = [[typeComponents objectAtIndex:2] intValue];
				NSArray *alphabet = [NSArray arrayWithObjects:@"a", @"b", @"c", @"d", @"e", @"f", nil];
				NSString *glassLetter = [alphabet objectAtIndex:glassNumber - 1];
				glassBaseName = [NSString stringWithFormat:@"%@%@-Glass", levelSuffix, glassLetter];
			}
			else
			{
				glassBaseName = [NSString stringWithFormat:@"%@-Glass", levelSuffix];
			}
			
			type = [type substringToIndex:7];
		
			NSMutableDictionary *mutableInstanceComponentsDict = [NSMutableDictionary dictionaryWithDictionary:instanceComponentsDict];
			
			NSMutableDictionary *mutableRenderInstanceComponentDict = [NSMutableDictionary dictionaryWithDictionary:[instanceComponentsDict objectForKey:@"render"]];
			NSString *imageFileName = [NSString stringWithFormat:@"%@.png", glassBaseName];
			[mutableRenderInstanceComponentDict setObject:imageFileName forKey:@"overrideTextureFile"];
			[mutableInstanceComponentsDict setObject:mutableRenderInstanceComponentDict forKey:@"render"];
			
			NSMutableDictionary *mutablePhysicsInstanceComponentDict = [NSMutableDictionary dictionaryWithDictionary:[instanceComponentsDict objectForKey:@"physics"]];
			NSString *bodyName = glassBaseName;
			[mutablePhysicsInstanceComponentDict setObject:bodyName forKey:@"overrideBodyName"];
			[mutableInstanceComponentsDict setObject:mutablePhysicsInstanceComponentDict forKey:@"physics"];
			 
			 instanceComponentsDict = mutableInstanceComponentsDict;
		}
		else if ([type hasPrefix:@"BEEATER-"] &&
				 [instanceComponentsDict objectForKey:@"beeater"] != nil)
		{
			NSMutableDictionary *mutableInstanceComponentsDict = [NSMutableDictionary dictionaryWithDictionary:instanceComponentsDict];
			
			NSMutableDictionary *mutableBeeaterInstanceComponentDict = [NSMutableDictionary dictionaryWithDictionary:[instanceComponentsDict objectForKey:@"beeater"]];
			NSString *containedBeeTypeAsString = [mutableBeeaterInstanceComponentDict objectForKey:@"containedBeeType"];
			[mutableInstanceComponentsDict removeObjectForKey:@"beeater"];
			
			NSMutableDictionary *capturedInstanceComponentDict = [NSMutableDictionary dictionary];
			[capturedInstanceComponentDict setObject:containedBeeTypeAsString forKey:@"containedBeeType"];
			[mutableInstanceComponentsDict setObject:capturedInstanceComponentDict forKey:@"captured"];
			
			instanceComponentsDict = mutableInstanceComponentsDict;
		}
		else if ([type isEqualToString:@"FROZEN-TBEE"] &&
				 [instanceComponentsDict objectForKey:@"captured"] == nil)
		{
			NSMutableDictionary *mutableInstanceComponentsDict = [NSMutableDictionary dictionaryWithDictionary:instanceComponentsDict];
			
			NSMutableDictionary *capturedInstanceComponentDict = [NSMutableDictionary dictionary];
			[capturedInstanceComponentDict setObject:[[BeeType TBEE] name] forKey:@"containedBeeType"];
			[mutableInstanceComponentsDict setObject:capturedInstanceComponentDict forKey:@"captured"];
			
			instanceComponentsDict = mutableInstanceComponentsDict;
		}
		
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
