//
//  EntityDescriptionLoader.h
//  Beezle
//
//  Created by KM Lagerstrom on 05/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@class EntityDescription;

@interface EntityDescriptionLoader : NSObject

+(EntityDescriptionLoader *) sharedLoader;

-(EntityDescription *) loadEntityDescription:(NSString *)type;

@end
