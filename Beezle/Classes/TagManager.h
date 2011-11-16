//
//  TagManager.h
//  Beezle
//
//  Created by Me on 10/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Entity.h"

@interface TagManager : NSObject
{
    NSMutableDictionary *_entitiesByTag;
}

-(void) registerEntity:(Entity *)entity withTag:(NSString *)tag;
-(Entity *) getEntity:(NSString *)tag;
-(void) remove:(Entity *)entity;

@end
