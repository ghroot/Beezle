//
//  AbstractSystem.h
//  Beezle
//
//  Created by Me on 08/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AbstractComponent.h"

#import "Entity.h"

@interface AbstractSystem : NSObject
{
    NSMutableArray *_entities;
}

-(void) entityAdded:(Entity *)entity;
-(void) update;

@end
