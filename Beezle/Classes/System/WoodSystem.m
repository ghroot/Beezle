//
//  WoodSystem.m
//  Beezle
//
//  Created by KM Lagerstrom on 15/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WoodSystem.h"
#import "EntityUtil.h"
#import "NotificationProcessor.h"
#import "NotificationTypes.h"
#import "NSObject+PWObject.h"
#import "PhysicsComponent.h"
#import "RenderComponent.h"
#import "RenderSprite.h"
#import "WoodComponent.h"

#define DELAY_PER_WOOD_PIECE 0.3f

@interface WoodSystem()

-(void) handleEntityDisposed:(NSNotification *)notification;
-(void) animateAndDestroyWoodPiece:(NSArray *)renderSprites atIndex:(int)index stepsFromStart:(int)stepsFromStart continueUp:(BOOL)continueUp continueDown:(BOOL)continueDown;

@end

@implementation WoodSystem

-(id) init
{
	if (self = [super init])
	{
		_notificationProcessor = [[NotificationProcessor alloc] initWithTarget:self];
		[_notificationProcessor registerNotification:GAME_NOTIFICATION_ENTITY_DISPOSED withSelector:@selector(handleEntityDisposed:)];
	}
	return self;
}

-(void) dealloc
{
	[_notificationProcessor release];
	
	[super dealloc];
}

-(void) activate
{
	[super activate];
	
	[_notificationProcessor activate];
}

-(void) deactivate
{
	[super deactivate];
	
	[_notificationProcessor deactivate];
}

-(void) begin
{
	[_notificationProcessor processNotifications];
}

-(void) handleEntityDisposed:(NSNotification *)notification
{
	Entity *entity = [[notification userInfo] objectForKey:@"entity"];
	if ([entity hasComponent:[WoodComponent class]])
	{
		WoodComponent *woodComponent = [WoodComponent getFrom:entity];
		if ([woodComponent shapeIndexAtSawCollision] >= 0)
		{
			NSArray *woodRenderSprites = [[RenderComponent getFrom:entity] renderSprites];
			[self animateAndDestroyWoodPiece:woodRenderSprites atIndex:[woodComponent shapeIndexAtSawCollision] stepsFromStart:0 continueUp:TRUE continueDown:TRUE];
			
			// TODO: Don't just disable physics, remove at end of last animation
			[EntityUtil disablePhysics:entity];
		}
		else
		{
			[EntityUtil animateAndDeleteEntity:entity animationName:@"Wood-Split"];
		}
	}
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
