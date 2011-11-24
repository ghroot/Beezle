//
//  TagManager.h
//  Beezle
//
//  Created by Me on 10/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

@class Entity;

@interface TagManager : NSObject
{
    NSMutableDictionary *_entitiesByTag;
}

-(void) registerEntity:(Entity *)entity withTag:(NSString *)tag;
-(Entity *) getEntity:(NSString *)tag;
-(void) removeEntity:(Entity *)entity;

@end
