//
//  ArtemisTests.m
//  ArtemisTests
//
//  Created by Me on 16/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ArtemisTests.h"

@implementation ArtemisTests

- (void)setUp
{
    [super setUp];
    
    _world = [[World alloc] init];
}

- (void)tearDown
{
    [_world release];
    
    [super tearDown];
}

-(void) test_givenEntityCreated_canRetrieveItById
{
    Entity *entity = [_world createEntity];
    Entity *retrievedEntity = [_world getEntity:[entity entityId]];
    
    STAssertNotNil(retrievedEntity, @"");
}

-(void) test_givenComponentAddedToEntity_canBeRetrieved
{
    Entity *entity = [_world createEntity];
    Component *component = [[[Component alloc] init] autorelease];
    [entity addComponent:component];
    Component *retrievedComponent = [entity getComponent:[Component class]];
	NSArray *retrievedComponents = [entity getComponents];
    
    STAssertNotNil(retrievedComponent, @"");
	STAssertTrue([retrievedComponents count] == 1, @"");
}

-(void) test_givenSystemSetOnSystemManager_canBeRetrieved
{
    EntitySystem *system = [[[EntitySystem alloc] init] autorelease];
    [[_world systemManager] setSystem:system];
    EntitySystem *retrievedSystem = [[_world systemManager] getSystem:[EntitySystem class]];
    
    STAssertNotNil(retrievedSystem, @"");
}

-(void) test_givenEntityCreated_whenDeleted_cannotBeRetrieved
{
    Entity *entity = [_world createEntity];
    NSNumber *entityId = [entity entityId];
    [entity deleteEntity];
    [_world loopStart];
    Entity *retrievedEntity = [_world getEntity:entityId];
    
    STAssertNil(retrievedEntity, @"");
}

-(void) test_givenEntityCreatedAndTagged_whenDeleted_cannotBeRetrievedFromTagManager
{
    TagManager *tagManager = (TagManager *)[[_world systemManager] getSystem:[TagManager class]];
    NSString *tag = @"TAG";
    Entity *entity = [_world createEntity];
    [tagManager registerEntity:entity withTag:tag];
    [entity deleteEntity];
    [_world loopStart];
    Entity *retrievedEntity = [tagManager getEntity:tag];
    
    STAssertNil(retrievedEntity, @"");
}

-(void) test_givenEntityDeleted_ifLoopStartIsNotCalled_entityCanStillBeRetrieved
{
    Entity *entity = [_world createEntity];
    NSNumber *entityId = [entity entityId];
    [entity deleteEntity];
    Entity *retrievedEntity = [_world getEntity:entityId];
    
    STAssertNotNil(retrievedEntity, @"");
}

-(void) test_givenEntityDeleted_componentCanNotBeRetrieved
{
    Entity *entity = [_world createEntity];
    Component *component = [[[Component alloc] init] autorelease];
    [entity addComponent:component];
    [entity deleteEntity];
    [_world loopStart];
    Component *retrievedComponent = [entity getComponent:[Component class]];
    
    STAssertNil(retrievedComponent, @"");
}

-(void) test_givenEntityHasNeededComponents_entityIsAddedToSystem
{
    EntityComponentSystem *system = [[[EntityComponentSystem alloc] initWithUsedComponentClasses:[NSMutableArray arrayWithObject:[Component class]]] autorelease];
    [[_world systemManager] setSystem:system];
    Entity *entity = [_world createEntity];
    Component *component = [[[Component alloc] init] autorelease];
    [entity addComponent:component];
    [entity refresh];
    [_world loopStart];
    BOOL systemHasEntity = [system hasEntity:entity];
    
    STAssertTrue(systemHasEntity, @"");
}

-(void) test_givenEntityDoesNotHaveNeededComponents_entityIsNotAddedToSystem
{
    EntityComponentSystem *system = [[[EntityComponentSystem alloc] initWithUsedComponentClasses:[NSMutableArray arrayWithObject:[Component class]]] autorelease];
    [[_world systemManager] setSystem:system];
    Entity *entity = [_world createEntity];
    [entity refresh];
    [_world loopStart];
    BOOL systemHasEntity = [system hasEntity:entity];
    
    STAssertFalse(systemHasEntity, @"");
}

@end
