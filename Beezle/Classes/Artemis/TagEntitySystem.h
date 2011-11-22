//
//  TagEntitySystem.h
//  Beezle
//
//  Created by Me on 21/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EntitySystem.h"

@class Entity;

@interface TagEntitySystem : EntitySystem
{
    NSString *_tag;
}

-(id) initWithTag:(NSString *)tag;
-(void) processTaggedEntity:(Entity *)entity;

@end
