//
//  SlingerControlSystem.m
//  Beezle
//
//  Created by Me on 13/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SlingerControlSystem.h"
#import "BeeType.h"
#import "EntityFactory.h"
#import "EntityUtil.h"
#import "NotificationTypes.h"
#import "InputAction.h"
#import "InputSystem.h"
#import "RenderComponent.h"
#import "SlingerComponent.h"
#import "SoundManager.h"
#import "TouchTypes.h"
#import "TrajectoryComponent.h"
#import "TransformComponent.h"

#define SLINGER_POWER_SENSITIVITY 7
#define SLINGER_MIN_POWER 100
#define SLINGER_MAX_POWER 400
#define SLINGER_AIM_SENSITIVITY 4.0
#define AIM_POLLEN_INTERVAL 16
#define SCALE_AT_MIN_POWER 1.0f
#define SCALE_AT_MAX_POWER 0.5f

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

-(void) initialise
{
	_inputSystem = (InputSystem *)[[_world systemManager] getSystem:[InputSystem class]];
}

-(void) processTaggedEntity:(Entity *)entity
{
    TrajectoryComponent *trajectoryComponent = [TrajectoryComponent getFrom:entity];
    if ([_inputSystem hasInputActions])
    {
        InputAction *nextInputAction = [_inputSystem popInputAction];
        
		SlingerComponent *slingerComponent = [SlingerComponent getFrom:entity];
        TransformComponent *transformComponent = [TransformComponent getFrom:entity];
        
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
				float modifiedPower = power * [[slingerComponent loadedBeeType] slingerShootSpeedModifier];
				
				// Trajectory
				float slingerHeight = 25.0f;
				CGPoint slingerTipVector = CGPointMake(cosf(aimAngle) * slingerHeight, sinf(aimAngle) * slingerHeight);
				CGPoint tipPosition = CGPointMake([transformComponent position].x + slingerTipVector.x, [transformComponent position].y + slingerTipVector.y);
				[trajectoryComponent setStartPoint:tipPosition];
				[trajectoryComponent setAngle:aimAngle];
				[trajectoryComponent setPower:modifiedPower];
                
				// Rotation
                float compatibleAimAngle = 360 - CC_RADIANS_TO_DEGREES(aimAngle) + 90 + 180;
                [transformComponent setRotation:compatibleAimAngle];
				
				// Strech scale
				float percent = (power - SLINGER_MIN_POWER) / (SLINGER_MAX_POWER - SLINGER_MIN_POWER);
				float scale = SCALE_AT_MIN_POWER + percent * (SCALE_AT_MAX_POWER - SCALE_AT_MIN_POWER);
				[transformComponent setScale:CGPointMake(1.0f, scale)];
				
				// Game notification
				[[NSNotificationCenter defaultCenter] postNotificationName:GAME_NOTIFICATION_SLINGER_ROTATED object:self];
                
                break;
            }
            case TOUCH_ENDED:
            {
				if (![trajectoryComponent isZero])
				{
					// Create bee
					Entity *beeEntity = [EntityFactory createBee:_world withBeeType:[slingerComponent loadedBeeType] andVelocity:[trajectoryComponent startVelocity]];
					[EntityUtil setEntityPosition:beeEntity position:[trajectoryComponent startPoint]];
					
					[slingerComponent clearLoadedBee];
					
					[transformComponent setScale:CGPointMake(1.0f, 1.0f)];
					
					[[SoundManager sharedManager] playSound:@"33369__herbertboland__mouthpop.wav"];
					
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
            Entity *aimPollenEntity = [EntityFactory createAimPollen:_world withVelocity:[trajectoryComponent startVelocity]];
            [EntityUtil setEntityPosition:aimPollenEntity position:[trajectoryComponent startPoint]];
			
            _aimPollenCountdown = AIM_POLLEN_INTERVAL;
        }
    }
}

@end
