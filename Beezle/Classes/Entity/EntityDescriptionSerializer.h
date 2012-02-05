//
//  EntityDescriptionSerializer.h
//  Beezle
//
//  Created by KM Lagerstrom on 05/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@class EntityDescription;

@interface EntityDescriptionSerializer : NSObject

+(EntityDescriptionSerializer *) sharedSerializer;

-(EntityDescription *) entityDescriptionFromDictionary:(NSDictionary *)dict;

@end
