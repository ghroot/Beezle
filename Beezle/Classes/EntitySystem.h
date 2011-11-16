//
//  EntitySystem.h
//  Beezle
//
//  Created by Me on 08/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Component.h"
#import "Entity.h"

@interface EntitySystem : NSObject
{
    World *_world;
    NSMutableArray *_usedComponentClasses;
    NSMutableArray *_entities;
}

@property (nonatomic, assign) World *world;

-(id) initWithUsedComponentClasses:(NSMutableArray *)usedComponentClasses;
-(void) begin;
-(void) process;
-(void) end;
-(void) processEntities:(NSArray *)entities;
-(BOOL) checkProcessing;
-(void) initialise;
-(void) entityAdded:(Entity *)entity;
-(void) entityRemoved:(Entity *)entity;
-(void) entityChanged:(Entity *)entity;
-(void) removeEntity:(Entity *)entity;
-(BOOL) hasEntity:(Entity *)entity;

@end
