//
//  GameRulesSystem.m
//  Beezle
//
//  Created by Me on 10/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameRulesSystem.h"
#import "BeeTypes.h"
#import "SlingerComponent.h"

@interface GameRulesSystem()

-(void) updateIsLevelCompleted;
-(void) updateIsLevelFailed;
-(void) updateIsBeeFlying;
-(void) updateBeeQueue;

@end

@implementation GameRulesSystem

@synthesize isLevelCompleted = _isLevelCompleted;
@synthesize isLevelFailed = _isLevelFailed;
@synthesize isBeeFlying = _isBeeFlying;
@synthesize beeQueue = _beeQueue;

-(id) init
{
    if (self = [super init])
    {
        _beeQueue = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void) dealloc
{
    [_beeQueue release];
    
    [super dealloc];
}

-(void) begin
{
    [self updateIsLevelCompleted];
    [self updateIsLevelFailed];
    [self updateIsBeeFlying];
    [self updateBeeQueue];
}

-(void) updateIsLevelCompleted
{
    GroupManager *groupManager = (GroupManager *)[_world getManager:[GroupManager class]];
    NSArray *beeaterEntities = [groupManager getEntitiesInGroup:@"BEEATERS"];
    NSArray *beeEntities = [groupManager getEntitiesInGroup:@"BEES"];
    
    _isLevelCompleted = [beeaterEntities count] == 0 && [beeEntities count] == 0;
}

-(void) updateIsLevelFailed
{
    TagManager *tagManager = (TagManager *)[_world getManager:[TagManager class]];
    Entity *slingerEntity = [tagManager getEntity:@"SLINGER"];
    SlingerComponent *slingerComponent = (SlingerComponent *)[slingerEntity getComponent:[SlingerComponent class]];
    
    GroupManager *groupManager = (GroupManager *)[_world getManager:[GroupManager class]];
    NSArray *beeEntities = [groupManager getEntitiesInGroup:@"BEES"];
    
    _isLevelFailed = ![slingerComponent hasMoreBees] && [beeEntities count] == 0;
}

-(void) updateIsBeeFlying
{
    GroupManager *groupManager = (GroupManager *)[_world getManager:[GroupManager class]];
    NSArray *beeEntities = [groupManager getEntitiesInGroup:@"BEES"];
    
    _isBeeFlying = [beeEntities count] > 0;
}

-(void) updateBeeQueue
{
    TagManager *tagManager = (TagManager *)[_world getManager:[TagManager class]];
    Entity *slingerEntity = [tagManager getEntity:@"SLINGER"];
    SlingerComponent *slingerComponent = (SlingerComponent *)[slingerEntity getComponent:[SlingerComponent class]];
    
    [_beeQueue removeAllObjects];
    for (BeeTypes *beeType in [slingerComponent queuedBeeTypes])
    {
        [_beeQueue addObject:beeType];
    }
}

@end
