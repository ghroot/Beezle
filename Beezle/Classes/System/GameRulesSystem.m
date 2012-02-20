//
//  GameRulesSystem.m
//  Beezle
//
//  Created by Me on 10/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameRulesSystem.h"
#import "DisposableComponent.h"
#import "GateComponent.h"
#import "SlingerComponent.h"

@interface GameRulesSystem()

-(void) updateIsLevelCompleted;
-(void) updateIsLevelFailed;
-(void) updateIsBeeFlying;

-(int) countNonDisposedEntitiesInGroup:(NSString *)groupName;
-(BOOL) hasUnopenedGates;

@end

@implementation GameRulesSystem

@synthesize isLevelCompleted = _isLevelCompleted;
@synthesize isLevelFailed = _isLevelFailed;
@synthesize isBeeFlying = _isBeeFlying;

-(void) begin
{
    [self updateIsLevelCompleted];
    [self updateIsLevelFailed];
    [self updateIsBeeFlying];
}

-(void) updateIsLevelCompleted
{
	int numberOfUndisposedBeeaters = [self countNonDisposedEntitiesInGroup:@"BEEATERS"];
							   
    _isLevelCompleted = numberOfUndisposedBeeaters == 0 &&
		[self hasUnopenedGates] == 0;
}

-(void) updateIsLevelFailed
{
    TagManager *tagManager = (TagManager *)[_world getManager:[TagManager class]];
    Entity *slingerEntity = [tagManager getEntity:@"SLINGER"];
    SlingerComponent *slingerComponent = [SlingerComponent getFrom:slingerEntity];
    
	int numberOfUndisposedBees = [self countNonDisposedEntitiesInGroup:@"BEES"];
	int numberOfUndisposedBeeaters = [self countNonDisposedEntitiesInGroup:@"BEEATERS"];
    
    _isLevelFailed = ![slingerComponent hasMoreBees] &&
		![slingerComponent hasLoadedBee] &&
		numberOfUndisposedBees == 0 &&
		numberOfUndisposedBeeaters > 0;
}

-(void) updateIsBeeFlying
{
	int numberOfUndisposedBees = [self countNonDisposedEntitiesInGroup:@"BEES"];
    _isBeeFlying = numberOfUndisposedBees > 0;
}
										
-(int) countNonDisposedEntitiesInGroup:(NSString *)groupName
{
	GroupManager *groupManager = (GroupManager *)[_world getManager:[GroupManager class]];
	NSArray *entities = [groupManager getEntitiesInGroup:groupName];
	int count = 0;
	for (Entity *entity in entities)
	{
		if ([entity hasComponent:[DisposableComponent class]] &&
			![[DisposableComponent getFrom:entity] isDisposed])
		{
			count++;
		}
	}
	return count;
}

-(BOOL) hasUnopenedGates
{
	GroupManager *groupManager = (GroupManager *)[_world getManager:[GroupManager class]];
	NSArray *gateEntities = [groupManager getEntitiesInGroup:@"GATES"];
	for (Entity *gateEntity in gateEntities)
	{
		if (![[GateComponent getFrom:gateEntity] isOpened])
		{
			return TRUE;
		}
	}
	return FALSE;
}

@end
