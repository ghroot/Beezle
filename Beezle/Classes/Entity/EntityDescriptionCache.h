//
//  EntityDescriptionCache.h
//  Beezle
//
//  Created by KM Lagerstrom on 05/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EntityDescription.h"

@interface EntityDescriptionCache : NSObject
{
	NSMutableDictionary *_entityDescriptionsByType;
}

+(EntityDescriptionCache *) sharedCache;

-(void) addEntityDescription:(EntityDescription *)entityDescription;
-(EntityDescription *) entityDescriptionByType:(NSString *)type;
-(void) purgeCachedData;

@end
