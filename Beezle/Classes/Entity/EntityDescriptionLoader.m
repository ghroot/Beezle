//
//  EntityDescriptionLoader.m
//  Beezle
//
//  Created by KM Lagerstrom on 05/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EntityDescriptionLoader.h"
#import "EntityDescription.h"
#import "EntityDescriptionSerializer.h"

@interface EntityDescriptionLoader()

-(NSDictionary *) createDictionaryFromTemplate:(NSDictionary *)dict entityType:(NSString *)type;
-(NSString *) convertTypeToFileName:(NSString *)type;

@end

@implementation EntityDescriptionLoader

+(EntityDescriptionLoader *) sharedLoader
{
    static EntityDescriptionLoader *loader = 0;
    if (!loader)
    {
        loader = [[self alloc] init];
    }
    return loader;
}

-(EntityDescription *) loadEntityDescription:(NSString *)type
{
	NSString *fileName = [self convertTypeToFileName:type];
	NSString *filePath = [[CCFileUtils sharedFileUtils] fullPathFromRelativePath:fileName];
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    if ([dict objectForKey:@"template"] != nil)
    {
        dict = [self createDictionaryFromTemplate:dict entityType:type];
    }

    return [[EntityDescriptionSerializer sharedSerializer] entityDescriptionFromDictionary:dict];
}

-(NSDictionary *) createDictionaryFromTemplate:(NSDictionary *)dict entityType:(NSString *)type
{
    NSString *templateFileName = [dict objectForKey:@"template"];
    NSString *templateFilePath = [[CCFileUtils sharedFileUtils] fullPathFromRelativePath:templateFileName];
    NSDictionary *templateSubstitutions = [dict objectForKey:@"templateSubstitutions"];
    
    NSString *error;
    NSDictionary *templateDict = [NSDictionary dictionaryWithContentsOfFile:templateFilePath];
    NSData *templateData = [NSPropertyListSerialization dataFromPropertyList:templateDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
    NSString *templateFileAsString = [[NSString alloc] initWithData:templateData encoding:NSUTF8StringEncoding];

    // TODO: This should work, but doesn't... Possibly due to plist file not being correct encoding (UTF-8)
//    NSError *error;
//    NSStringEncoding encoding;
//    NSString *templateFileAsString = [NSString stringWithContentsOfFile:templateFilePath usedEncoding:&encoding error:&error];
    
    NSString *templateFileAsStringWithReplacements = templateFileAsString;
    for (NSString *tokenToReplace in templateSubstitutions)
    {
        NSString *stringToReplace = [NSString stringWithFormat:@"%%%@%%", tokenToReplace];
        NSString *stringToReplaceWith = [templateSubstitutions objectForKey:tokenToReplace];
        
        templateFileAsStringWithReplacements = [templateFileAsStringWithReplacements stringByReplacingOccurrencesOfString:stringToReplace withString:stringToReplaceWith];
    }
    
    NSData *plistData = [templateFileAsStringWithReplacements dataUsingEncoding:NSUTF8StringEncoding];
    NSPropertyListFormat format;
    NSMutableDictionary *templateDictWithReplacements = [NSPropertyListSerialization propertyListFromData:plistData mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&error];
	
	[templateDictWithReplacements setObject:type forKey:@"type"];
    
    return templateDictWithReplacements;
}

-(NSString *) convertTypeToFileName:(NSString *)type
{
	NSArray *stringComponents = [type componentsSeparatedByString:@"-"];
	NSMutableString *capitalizedString = [NSMutableString string];
	for (NSString *stringComponent in stringComponents)
	{
		[capitalizedString appendString:[stringComponent capitalizedString]];
		if (stringComponent != [stringComponents lastObject])
		{
			[capitalizedString appendString:@"-"];
		}
	}
	return [NSString stringWithFormat:@"%@.plist", capitalizedString];
}

@end
