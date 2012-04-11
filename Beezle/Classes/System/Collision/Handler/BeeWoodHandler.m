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

@implementation BeeWoodHandler

-(void) handleCollision:(Collision *)collision
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
			int shapeIndex = [[physicsComponent shapes] indexOfObject:[collision secondShape]];
			
			float delayPerWoodPiece = 0.3f;
			
			RenderComponent *renderComponent = [RenderComponent getFrom:woodEntity];
			NSArray *woodRenderSprites = [renderComponent renderSprites];
			RenderSprite *hitWoodRenderSprite = [woodRenderSprites objectAtIndex:shapeIndex];
			[hitWoodRenderSprite playDefaultDestroyAnimation];
			int startRenderSpriteIndex = shapeIndex;
			int currentRenderSpriteIndexDelta = 1;
			BOOL animationWithDestroyEntityCallbackHasBeenPlayed = FALSE;
			while (true)
			{
				int nextRenderSpriteIndex = startRenderSpriteIndex + currentRenderSpriteIndexDelta;
				RenderSprite *nextRenderSprite = nil;
				if (nextRenderSpriteIndex < [woodRenderSprites count])
				{
					nextRenderSprite = [woodRenderSprites objectAtIndex:nextRenderSpriteIndex];
					if (!animationWithDestroyEntityCallbackHasBeenPlayed &&
						nextRenderSpriteIndex == [woodRenderSprites count] - 1)
					{
						[self performBlock:^(void){
							[nextRenderSprite playAnimation:[nextRenderSprite randomDefaultDestroyAnimationName] withCallbackTarget:woodEntity andCallbackSelector:@selector(deleteEntity)];
						} afterDelay:currentRenderSpriteIndexDelta * delayPerWoodPiece];
						
						animationWithDestroyEntityCallbackHasBeenPlayed = TRUE;
					}
					else
					{
						[self performBlock:^(void){
							[nextRenderSprite playDefaultDestroyAnimation];
						} afterDelay:currentRenderSpriteIndexDelta * delayPerWoodPiece];
					}
				}
				
				int previousRenderSpriteIndex = startRenderSpriteIndex - currentRenderSpriteIndexDelta;
				RenderSprite *previousRenderSprite = nil;
				if (previousRenderSpriteIndex >= 0)
				{
					previousRenderSprite = [woodRenderSprites objectAtIndex:previousRenderSpriteIndex];
					if (!animationWithDestroyEntityCallbackHasBeenPlayed &&
						previousRenderSpriteIndex == 0)
					{
						[self performBlock:^(void){
							[previousRenderSprite playAnimation:[previousRenderSprite randomDefaultDestroyAnimationName] withCallbackTarget:woodEntity andCallbackSelector:@selector(deleteEntity)];
						} afterDelay:currentRenderSpriteIndexDelta * delayPerWoodPiece];
						
						animationWithDestroyEntityCallbackHasBeenPlayed = TRUE;
					}
					else
					{
						[self performBlock:^(void){
							[previousRenderSprite playDefaultDestroyAnimation];
						} afterDelay:currentRenderSpriteIndexDelta * delayPerWoodPiece];
					}
				}
				
				if (nextRenderSprite != nil ||
					previousRenderSprite != nil)
				{
					currentRenderSpriteIndexDelta++;
				}
				else
				{
					break;
				}
			}
			
            [EntityUtil setEntityDisposed:beeEntity];
			[beeEntity deleteEntity];
			
			[[SoundManager sharedManager] playSound:@"18339__jppi-stu__sw-paper-crumple-1.aiff"];
		}
	}
}

@end
