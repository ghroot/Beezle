//
//  GameRulesSystem.m
//  Beezle
//
//  Created by Me on 10/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameRulesSystem.h"
#import "DisposableComponent.h"
#import "EntityUtil.h"
#import "LevelSession.h"
#import "PlayerInformation.h"
#import "SlingerComponent.h"

@interface GameRulesSystem()

-(void) updateIsLevelCompleted;
-(void) updateIsLevelFailed;

-(int) countNonDisposedEntitiesInGroup:(NSString *)groupName;

@end

@implementation GameRulesSystem

@synthesize isLevelCompleted = _isLevelCompleted;
@synthesize isLevelFailed = _isLevelFailed;

-(id) initWithLevelSession:(LevelSession *)levelSession
{
	if (self = [super init])
	{
		_levelSession = levelSession;
	}
	return self;
}

-(void) begin
{
    [self updateIsLevelCompleted];
    [self updateIsLevelFailed];
}

-(void) updateIsLevelCompleted
{
	int numberOfUndisposedBeeaters = [self countNonDisposedEntitiesInGroup:@"BEEATERS"];
	_isLevelCompleted = numberOfUndisposedBeeaters == 0;
}

-(void) updateIsLevelFailed
{
    TagManager *tagManager = (TagManager *)[_world getManager:[TagManager class]];
    Entity *slingerEntity = [tagManager getEntity:@"SLINGER"];
    SlingerComponent *slingerComponent = [SlingerComponent getFrom:slingerEntity];
	int numberOfUndisposedBees = [self countNonDisposedEntitiesInGroup:@"BEES"];
    
    _isLevelFailed = ![slingerComponent hasMoreBees] &&
		![slingerComponent hasLoadedBee] &&
		numberOfUndisposedBees == 0;
}
										
-(int) countNonDisposedEntitiesInGroup:(NSString *)groupName
{
	GroupManager *groupManager = (GroupManager *)[_world getManager:[GroupManager class]];
	NSArray *entities = [groupManager getEntitiesInGroup:groupName];
	int count = 0;
	for (Entity *entity in entities)
	{
        if (![EntityUtil isEntityDisposable:entity] ||
            ![EntityUtil isEntityDisposed:entity])
		{
			count++;
		}
	}
	return count;
}

@end
