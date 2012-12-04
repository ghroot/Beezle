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
	[_renderSystem setDisableSpriteSheetUnloading:TRUE];
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
								  @"MUMEE",
								  @"SLEEPING-MUMEE",
								  @"FROZEN-PIECE",
								  @"FROZEN-TBEE",
                                  @"BEEATER-BIRD-A",
                                  @"BEEATER-FISH-A",
                                  @"BEEATER-HANGING-A",
                                  @"BEEATER-LAND-A",
                                  @"BEEATER-HEAD-PIECE-A-1",
                                  @"BEEATER-HEAD-PIECE-A-2",
                                  @"BEEATER-HEAD-PIECE-A-3",
                                  @"BEEATER-HEAD-PIECE-A-4",
                                  @"BEEATER-HEAD-PIECE-A-5",
                                  @"BEEATER-BIRD-B",
                                  @"BEEATER-HANGING-B",
                                  @"BEEATER-LAND-B",
                                  @"BEEATER-HEAD-PIECE-B-1",
                                  @"BEEATER-HEAD-PIECE-B-2",
                                  @"BEEATER-HEAD-PIECE-B-3",
                                  @"BEEATER-HEAD-PIECE-B-4",
                                  @"BEEATER-HEAD-PIECE-B-5",
								  @"BEEATER-BIRD-C",
								  @"BEEATER-HANGING-C",
								  @"BEEATER-HANGING-C-REFLECTION",
								  @"BEEATER-LAND-C",
								  @"BEEATER-LAND-C-REFLECTION",
								  @"BEEATER-HEAD-PIECE-C-1",
								  @"BEEATER-HEAD-PIECE-C-2",
								  @"BEEATER-HEAD-PIECE-C-3",
								  @"BEEATER-HEAD-PIECE-C-4",
								  @"BEEATER-HEAD-PIECE-C-5",
								  @"BEEATER-BIRD-D",
								  @"BEEATER-HANGING-D",
								  @"BEEATER-LAND-D",
							  	  @"BEEATER-HEAD-PIECE-D-1",
								  @"BEEATER-HEAD-PIECE-D-2",
								  @"BEEATER-HEAD-PIECE-D-3",
								  @"BEEATER-HEAD-PIECE-D-4",
								  @"BEEATER-HEAD-PIECE-D-5",
								  @"BEEATER-BIRD-E",
								  @"BEEATER-HANGING-E",
								  @"BEEATER-LAND-E",
								  @"BEEATER-HEAD-PIECE-E-1",
								  @"BEEATER-HEAD-PIECE-E-2",
								  @"BEEATER-HEAD-PIECE-E-3",
								  @"BEEATER-HEAD-PIECE-E-4",
								  @"BEEATER-HEAD-PIECE-E-5",
                                  @"SUPER-BEEATER-A",
                                  @"SUPER-BEEATER-B",
                                  @"SUPER-BEEATER-C",
                                  @"SUPER-BEEATER-D",
                                  @"SUPER-BEEATER-E",
                                  @"EGG",
								  @"EGG-REFLECTION",
                                  @"HANGNEST-A",
                                  @"HANGNEST-B",
                                  @"HANGNEST-D",
                                  @"HANGNEST-E",
								  @"ICICLE",
								  @"ICICLE-SMALL",
                                  @"MUSHROOM",
								  @"POLLEN-GREEN",
								  @"POLLEN-ORANGE",
								  @"POLLEN-YELLOW",
                                  @"SMOKE-MUSHROOM",
                                  @"RAMP-A",
								  @"RAMP-B",
								  @"RAMP-C",
								  @"RAMP-D",
								  @"RAMP-E",
                                  @"RAMP-PIECE-A",
                                  @"RAMP-PIECE-SMALL-A",
								  @"RAMP-PIECE-B",
								  @"RAMP-PIECE-SMALL-B",
								  @"RAMP-PIECE-C",
								  @"RAMP-PIECE-SMALL-C",
								  @"RAMP-PIECE-D",
								  @"RAMP-PIECE-SMALL-D",
								  @"RAMP-PIECE-E",
								  @"RAMP-PIECE-SMALL-E",
                                  @"SLINGER",
                                  @"LAVA-SPLASH",
                                  @"WATER-SPLASH",
                                  @"WOOD",
                                  @"WOOD-2",
                                  @"WOOD-3",
                                  @"WOOD-4",
                                  @"BRANCH",
                                  @"CACTUS",
                                  @"EYES",
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
	[_world setDelta:(int)(1000.0f * delta)];
    
    [_renderSystem process];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	[_game popState];
    return TRUE;
}

@end
