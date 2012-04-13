//
//  BeeWoodHandler.m
//  Beezle
//
//  Created by Marcus on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BeeWoodHandler.h"
#import "BeeComponent.h"
#import "Collision.h"
#import "EntityUtil.h"
#import "NSObject+PWObject.h"
#import "PhysicsComponent.h"
#import "RenderComponent.h"
#import "RenderSprite.h"
#import "SoundManager.h"

#define DELAY_PER_WOOD_PIECE 0.3f

@interface BeeWoodHandler()

-(void) animateAndDestroyWoodPiece:(NSArray *)renderSprites atIndex:(int)index stepsFromStart:(int)stepsFromStart continueUp:(BOOL)continueUp continueDown:(BOOL)continueDown;

@end

@implementation BeeWoodHandler

-(BOOL) handleCollision:(Collision *)collision
{
    Entity *beeEntity = [collision firstEntity];
    Entity *woodEntity = [collision secondEntity];
    
    if (![EntityUtil isEntityDisposed:woodEntity])
	{
		BeeComponent *beeComponent = [BeeComponent getFrom:beeEntity];
		if ([beeComponent type] == [BeeType SAWEE])
		{
            [EntityUtil setEntityDisposed:woodEntity];
			
			PhysicsComponent *physicsComponent = [PhysicsComponent getFrom:woodEntity];
			int shapeIndexAtCollision = [[physicsComponent shapes] indexOfObject:[collision secondShape]];
            
            NSArray *woodRenderSprites = [[RenderComponent getFrom:woodEntity] renderSprites];
            [self animateAndDestroyWoodPiece:woodRenderSprites atIndex:shapeIndexAtCollision stepsFromStart:0 continueUp:TRUE continueDown:TRUE];
			
            // TODO: Don't just disable physics, remove at end of last animation
            PhysicsComponent *woodPhysicsComponent = [PhysicsComponent getFrom:woodEntity];
            [woodPhysicsComponent disable];
            [woodEntity refresh];
            
            [EntityUtil setEntityDisposed:beeEntity];
			[beeEntity deleteEntity];
			
			[[SoundManager sharedManager] playSound:@"18339__jppi-stu__sw-paper-crumple-1.aiff"];
		}
	}
    
    return TRUE;
}

-(void) animateAndDestroyWoodPiece:(NSArray *)renderSprites atIndex:(int)index stepsFromStart:(int)stepsFromStart continueUp:(BOOL)continueUp continueDown:(BOOL)continueDown
{
    if (index >= 0 &&
        index < [renderSprites count])
    {
        RenderSprite *renderSprite = [renderSprites objectAtIndex:index];
        
        [self performBlock:^(void){
            [renderSprite playDefaultDestroyAnimation];
        } afterDelay:stepsFromStart * DELAY_PER_WOOD_PIECE];
        
        if (continueUp)
        {
            [self animateAndDestroyWoodPiece:renderSprites atIndex:index + 1 stepsFromStart:stepsFromStart + 1 continueUp:TRUE continueDown:FALSE];
        }
        if (continueDown)
        {
            [self animateAndDestroyWoodPiece:renderSprites atIndex:index - 1 stepsFromStart:stepsFromStart + 1 continueUp:FALSE continueDown:TRUE];
        }
    }
}

@end
