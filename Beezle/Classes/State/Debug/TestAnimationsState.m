//
//  TestAnimationsState.m
//  Beezle
//
//  Created by Marcus on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TestAnimationsState.h"
#import "EntityFactory.h"
#import "EntityUtil.h"
#import "Game.h"
#import "RenderComponent.h"
#import "RenderSprite.h"
#import "RenderSystem.h"

@interface TestAnimationsState()

-(void) createEntities;

@end

@implementation TestAnimationsState

-(id) init
{
    if (self = [super init])
    {
        _needsLoadingState = TRUE;
    }
    return self;
}

-(void) dealloc
{
    [_world release];
    [_renderSystem release];
    
    [super dealloc];
}

-(void) initialise
{
    [super initialise];
    
    _layer = [CCLayer node];
    [self addChild:_layer];
    
    _world = [World new];
    _renderSystem = [[RenderSystem alloc] initWithLayer:_layer];
    [[_world systemManager] setSystem:_renderSystem];
    [[_world systemManager] initialiseAll];
    
    [self createEntities];
}

-(void) createEntities
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    NSMutableArray *entityTypesToTest = [NSMutableArray arrayWithObjects:
                                  @"AIM-POLLEN",
                                  @"BEE",
                                  @"BOMBEE",
                                  @"SAWEE",
                                  @"SPEEDEE-PUFF",
                                  @"SPEEDEE",
                                  @"SUMEE",
								  @"TBEE",
								  @"FROZEN-PIECE",
								  @"FROZEN-TBEE",
                                  @"BEEATER-BIRD-A",
                                  @"BEEATER-FISH-A",
                                  @"BEEATER-HANGING-A",
                                  @"BEEATER-LAND-A",
                                  @"BEEATER-PIECE-A",
                                  @"BEEATER-BIRD-B",
                                  @"BEEATER-HANGING-B",
                                  @"BEEATER-LAND-B",
                                  @"BEEATER-PIECE-B",
								  @"BEEATER-BIRD-C",
								  @"BEEATER-HANGING-C",
								  @"BEEATER-HANGING-C-REFLECTION",
								  @"BEEATER-LAND-C",
								  @"BEEATER-LAND-C-REFLECTION",
								  @"BEEATER-PIECE-C",
                                  @"SUPER-BEEATER",
                                  @"EGG",
								  @"EGG-REFLECTION",
                                  @"FLOATING-BLOCK-A",
                                  @"HANGNEST-A",
                                  @"HANGNEST-B",
                                  @"LEAF",
                                  @"MUSHROOM",
								  @"POLLEN-GREEN",
								  @"POLLEN-ORANGE",
								  @"POLLEN-YELLOW",
                                  @"SMOKE-MUSHROOM",
                                  @"RAMP-A",
								  @"RAMP-B",
								  @"RAMP-C",
                                  @"RAMP-PIECE-A",
								  @"RAMP-PIECE-B",
								  @"RAMP-PIECE-C",
                                  @"SLINGER",
                                  @"LAVA-SPLASH",
                                  @"WATER-SPLASH",
                                  @"WATERDROP",
                                  @"WOOD",
                                  @"WOOD-2",
                                  @"WOOD-3",
                                  @"WOOD-4",
                                  nil];
    
    for (NSString *entityType in entityTypesToTest)
    {
        Entity *entity = [EntityFactory createEntity:entityType world:_world];
        if (entity != nil)
        {
            CGPoint randomPosition;
            randomPosition.x = 20 + rand() % (int)(winSize.width - 40);
            randomPosition.y = 20 + rand() % (int)(winSize.height - 40);
            [EntityUtil setEntityPosition:entity position:randomPosition];
            
            RenderComponent *renderComponent = [RenderComponent getFrom:entity];
            if (renderComponent != nil &&
                ![renderComponent hasDefaultIdleAnimation])
            {
                for (RenderSprite *renderSprite in [renderComponent renderSprites])
                {
                    if ([renderSprite hasDefaultDestroyAnimation])
                    {
                        [renderSprite playAnimationLoop:[renderSprite randomDefaultDestroyAnimationName]];
                    }
                }
            }
        }
    }
}

-(void) update:(ccTime)delta
{
	[_world loopStart];
	[_world setDelta:(1000.0f * delta)];
    
    [_renderSystem process];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	[_game popState];
    return TRUE;
}

@end
