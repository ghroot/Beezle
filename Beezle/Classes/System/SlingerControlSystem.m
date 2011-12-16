//
//  SlingerControlSystem.m
//  Beezle
//
//  Created by Me on 13/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SlingerControlSystem.h"
#import "BeeTypes.h"
#import "EntityFactory.h"
#import "GameNotificationTypes.h"
#import "InputAction.h"
#import "InputSystem.h"
#import "RenderComponent.h"
#import "SimpleAudioEngine.h"
#import "SlingerComponent.h"
#import "TouchTypes.h"
#import "TrajectoryComponent.h"
#import "TransformComponent.h"

#define SLINGER_POWER_SENSITIVITY 7.5
#define SLINGER_MIN_POWER 150
#define SLINGER_MAX_POWER 400
#define SLINGER_AIM_SENSITIVITY 4.0
#define AIM_POLLEN_INTERVAL 16

@interface SlingerControlSystem()

-(float) calculateAimAngle:(CGPoint)touchLocation slingerLocation:(CGPoint)slingerLocation;
-(float) calculatePower:(CGPoint)touchLocation slingerLocation:(CGPoint)slingerLocation;
-(void) startShootingAimPollens;
-(void) stopShootingAimPollens;
-(void) shootAimPollens:(TrajectoryComponent *)trajectoryComponent;

@end

@implementation SlingerControlSystem

@synthesize startLocation;

-(id) init
{
    self = [super initWithTag:@"SLINGER"];
    return self;
}

-(void) processTaggedEntity:(Entity *)entity
{
    TrajectoryComponent *trajectoryComponent = (TrajectoryComponent *)[entity getComponent:[TrajectoryComponent class]];
    
    InputSystem *inputSystem = (InputSystem *)[[_world systemManager] getSystem:[InputSystem class]];
    if ([inputSystem hasInputActions])
    {
        InputAction *nextInputAction = [inputSystem popInputAction];
        
		SlingerComponent *slingerComponent = (SlingerComponent *)[entity getComponent:[SlingerComponent class]];
        TransformComponent *transformComponent = (TransformComponent *)[entity getComponent:[TransformComponent class]];
        RenderComponent *renderComponent = (RenderComponent *)[entity getComponent:[RenderComponent class]];
        
        switch ([nextInputAction touchType])
        {
            case TOUCH_BEGAN:
            {
                [self setStartLocation:[nextInputAction touchLocation]];
                [self startShootingAimPollens];
                break;
            }
            case TOUCH_MOVED:
            {
				if (![slingerComponent hasLoadedBee])
				{
					[slingerComponent loadNextBee];
					
					// Game notification
					[[NSNotificationCenter defaultCenter] postNotificationName:GAME_NOTIFICATION_BEE_LOADED object:self];
				}
				
				float aimAngle = [self calculateAimAngle:[nextInputAction touchLocation] slingerLocation:[transformComponent position]];
				float power = [self calculatePower:[nextInputAction touchLocation] slingerLocation:[transformComponent position]];
				
				// Trajectory
				float slingerHeight = 25.0f;
				CGPoint slingerTipVector = CGPointMake(cosf(aimAngle) * slingerHeight, sinf(aimAngle) * slingerHeight);
				CGPoint tipPosition = CGPointMake([transformComponent position].x + slingerTipVector.x, [transformComponent position].y + slingerTipVector.y);
				[trajectoryComponent setStartPoint:tipPosition];
				[trajectoryComponent setAngle:aimAngle];
				[trajectoryComponent setPower:power];
                
				// Rotation
                float compatibleAimAngle = 360 - CC_RADIANS_TO_DEGREES(aimAngle) + 90 + 180;
                [transformComponent setRotation:compatibleAimAngle];
				
				// Stretch animation
				NSArray *stretchAnimationNames = [NSArray arrayWithObjects:@"Sling-Stretch-1", @"Sling-Stretch-2", @"Sling-Stretch-3", @"Sling-Stretch-4", nil];
				float powerPerAnimation = (SLINGER_MAX_POWER - SLINGER_MIN_POWER) / [stretchAnimationNames count];
				int animationIndex = (int)floor((power - SLINGER_MIN_POWER) / powerPerAnimation);
				if (animationIndex >= [stretchAnimationNames count])
				{
					// This can happen if power is exactly maximum, then we use the last animation
					animationIndex = [stretchAnimationNames count] - 1;
				}
				NSString *strechAnimationName = (NSString *)[stretchAnimationNames objectAtIndex:animationIndex];
				[renderComponent playAnimation:strechAnimationName withLoops:-1];
                
                break;
            }
            case TOUCH_ENDED:
            {
				if (![trajectoryComponent isZero])
				{
					// Create bee
					[EntityFactory createBee:_world type:[slingerComponent loadedBeeType] withPosition:[trajectoryComponent startPoint] andVelocity:[trajectoryComponent startVelocity]];
					
					[slingerComponent clearLoadedBee];
					
					[renderComponent playAnimationsLoopLast:[NSArray arrayWithObjects:@"Sling-Shoot", @"Sling-Idle", nil]];
					
					[[SimpleAudioEngine sharedEngine] playEffect:@"33369__herbertboland__mouthpop.wav"];
					
					[trajectoryComponent reset];
					
					// Game notification
					[[NSNotificationCenter defaultCenter] postNotificationName:GAME_NOTIFICATION_BEE_FIRED object:self];
                }
                
                [self stopShootingAimPollens];
                
                break;
            }
        }
    }
    
    [self shootAimPollens:trajectoryComponent];
}

-(float) calculateAimAngle:(CGPoint)touchLocation slingerLocation:(CGPoint)slingerLocation
{
	CGPoint slingerToStartVector = ccpSub([self startLocation], slingerLocation);
	CGPoint slingerToTouchVector = ccpSub(touchLocation, slingerLocation);
	
	float startAngle = ccpToAngle(slingerToStartVector);
	float touchAngle = ccpToAngle(slingerToTouchVector);
	float angleDifference = touchAngle - startAngle;
	float aimAngle = startAngle + SLINGER_AIM_SENSITIVITY * angleDifference;
	
	return aimAngle;
}

-(float) calculatePower:(CGPoint)touchLocation slingerLocation:(CGPoint)slingerLocation
{
	CGPoint slingerToStartVector = ccpSub([self startLocation], slingerLocation);
	CGPoint slingerToTouchVector = ccpSub(touchLocation, slingerLocation);
	
	float slingerToStartVectorLength = sqrtf(slingerToStartVector.x * slingerToStartVector.x + slingerToStartVector.y * slingerToStartVector.y);
	float slingerToTouchVectorLength = sqrtf(slingerToTouchVector.x * slingerToTouchVector.x + slingerToTouchVector.y * slingerToTouchVector.y);
	float vectorLengthDifference = slingerToStartVectorLength - slingerToTouchVectorLength;
	float power = vectorLengthDifference; 
	power *= SLINGER_POWER_SENSITIVITY;
	power = max(power, SLINGER_MIN_POWER);
	power = min(power, SLINGER_MAX_POWER);
	
	return power;
}

-(void) startShootingAimPollens
{
    _aimPollenCountdown = AIM_POLLEN_INTERVAL;
    _isShootingAimPollens = TRUE;
}

-(void) stopShootingAimPollens
{
    _aimPollenCountdown = 0;
    _isShootingAimPollens = FALSE;
}

-(void) shootAimPollens:(TrajectoryComponent *)trajectoryComponent
{
    if (_isShootingAimPollens && ![trajectoryComponent isZero])
    {
        _aimPollenCountdown--;
        if (_aimPollenCountdown == 0)
        {
            [EntityFactory createAimPollen:_world withPosition:[trajectoryComponent startPoint] andVelocity:[trajectoryComponent startVelocity]];
            
            _aimPollenCountdown = AIM_POLLEN_INTERVAL;
        }
    }
}

@end
