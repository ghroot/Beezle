//
//  LevelLayout.m
//  Beezle
//
//  Created by Me on 03/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "LevelLayout.h"
#import "BeeaterComponent.h"
#import "EditComponent.h"
#import "LevelLayoutEntry.h"
#import "SlingerComponent.h"
#import "TransformComponent.h"

@interface LevelLayout()

-(void) addLevelLayoutEntry:(LevelLayoutEntry *)entry;
+(CGPoint) stringToPosition:(NSString *)string;

@end

@implementation LevelLayout

@synthesize levelName = _levelName;
@synthesize version = _version;
@synthesize entries = _entries;

+(LevelLayout *) layout
{
	return [[[self alloc] init] autorelease];
}

+(LevelLayout *) layoutWithContentsOfDictionary:(NSDictionary *)dict
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

+(LevelLayout *) layoutWithContentsOfFile:(NSString *)filePath
{
	return [self layoutWithContentsOfDictionary:[NSDictionary dictionaryWithContentsOfFile:filePath]];
}

+(LevelLayout *) layoutWithContentsOfWorld:(World *)world levelName:(NSString *)levelName version:(int)version
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

// Designated initialiser
-(id) initWithLevelName:(NSString *)levelName
{
	if (self = [super init])
    {
		_levelName = [levelName retain];
		_version = 0;
        _entries = [[NSMutableArray alloc] init];
    }
    return self;
}

-(id) init
{
    return [self initWithLevelName:nil];
}

-(void) dealloc
{
	[_levelName release];
    [_entries release];
    
    [super dealloc];
}

-(void) addLevelLayoutEntry:(LevelLayoutEntry *)entry
{
    [_entries addObject:entry];
}

-(NSDictionary *) layoutAsDictionary
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	
	[dict setObject:_levelName forKey:@"name"];
	[dict setObject:[NSNumber numberWithInt:_version] forKey:@"version"];
	
	NSMutableArray *entities = [NSMutableArray array];
	for (LevelLayoutEntry *levelLayoutEntry in _entries)
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

+(CGPoint) stringToPosition:(NSString *)string
{
    NSString *modifiedString = string;
    modifiedString = [modifiedString stringByReplacingOccurrencesOfString:@"{ " withString:@""];
    modifiedString = [modifiedString stringByReplacingOccurrencesOfString:@" }" withString:@""];
    NSArray *array = [modifiedString componentsSeparatedByString:@","];
    return CGPointMake([[array objectAtIndex:0] floatValue], [[array objectAtIndex:1] floatValue]);
}

@end
