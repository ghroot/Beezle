//
//  EntityProcessingSystem.h
//  Beezle
//
//  Created by Me on 10/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EntitySystem.h"

@interface EntityProcessingSystem : EntitySystem

-(id) initWithUsedComponentClasses:(NSMutableArray *)usedComponentClasses;
-(void) processEntity:(Entity *)entity;

@end
