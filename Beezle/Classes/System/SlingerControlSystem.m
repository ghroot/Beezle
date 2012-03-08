//
//  SlingerControlSystem.m
//  Beezle
//
//  Created by Me on 13/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SlingerControlSystem.h"
#import "BeeComponent.h"
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
#import "Utils.h"

#define SLINGER_POWER_SENSITIVITY 7.5f
#define SLINGER_MIN_POWER 100
#define SLINGER_MAX_POWER 400
#define SLINGER_AIM_SENSITIVITY 7.0f
#define SLINGER_STRETCH_SOUND_SCALE 0.8f
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

-(id) init
{
    self = [super initWithUsedComponentClasses:[NSArray arrayWithObject:[SlingerComponent class]]];
    return self;
}

-(void) initialise
{
	_inputSystem = (InputSystem *)[[_world systemManager] getSystem:[InputSystem class]];
}

-(void) entityAdded:(Entity *)entity
{
	[[SlingerComponent getFrom:entity] setState:SLINGER_STATE_IDLE];
}

-(void) processEntity:(Entity *)entity
{
    TrajectoryComponent *trajectoryComponent = [TrajectoryComponent getFrom:entity];
	
    while ([_inputSystem hasInputActions])
    {
        InputAction *nextInputAction = [_inputSystem popInputAction];
        
		SlingerComponent *slingerComponent = [SlingerComponent getFrom:entity];
        TransformComponent *transformComponent = [TransformComponent getFrom:entity];
		RenderComponent *renderComponent = [RenderComponent getFrom:entity];
        
        switch ([nextInputAction touchType])
        {
            case TOUCH_BEGAN:
            {
				if ([slingerComponent state] == SLINGER_STATE_IDLE)
				{
					_startLocation = [nextInputAction touchLocation];
					_currentAngle = CC_DEGREES_TO_RADIANS(360 - [transformComponent rotation] + 270);
					[self startShootingAimPollens];
					
					_stretchSoundPlayed = FALSE;
					
					[slingerComponent setState:SLINGER_STATE_AIMING];
				}
                break;
            }
            case TOUCH_MOVED:
            {
				if ([slingerComponent state] == SLINGER_STATE_AIMING)
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
					float compatibleAimAngle = [Utils unwindAngleDegrees:360 - CC_RADIANS_TO_DEGREES(aimAngle) + 270];
					[transformComponent setRotation:compatibleAimAngle];
					
					// Strech scale
					float percent = (power - SLINGER_MIN_POWER) / (SLINGER_MAX_POWER - SLINGER_MIN_POWER);
					float scale = SCALE_AT_MIN_POWER + percent * (SCALE_AT_MAX_POWER - SCALE_AT_MIN_POWER);
					[transformComponent setScale:CGPointMake(1.0f, scale)];
					
					if (!_stretchSoundPlayed &&
						scale <= SLINGER_STRETCH_SOUND_SCALE)
					{
						[[SoundManager sharedManager] playSound:@"SlingerStretch"];
						_stretchSoundPlayed = TRUE;
					}
                }
                break;
            }
            case TOUCH_ENDED:
            {
				if ([slingerComponent state] == SLINGER_STATE_AIMING)
				{
					if (![trajectoryComponent isZero])
					{
						// Create bee
						Entity *beeEntity = [EntityFactory createBee:_world withBeeType:[slingerComponent loadedBeeType] andVelocity:[trajectoryComponent startVelocity]];
						[EntityUtil setEntityPosition:beeEntity position:[trajectoryComponent startPoint]];
						[EntityUtil setEntityRotation:beeEntity rotation:[transformComponent rotation] + 90];
						
						[transformComponent setScale:CGPointMake(1.0f, 1.0f)];
						
						[renderComponent playAnimationsLoopLast:[NSArray arrayWithObjects:@"Sling-Shoot", @"Sling-Idle", nil]];
						
						[[SoundManager sharedManager] stopSound:@"SlingerStretch"];
						[[SoundManager sharedManager] playSound:@"33369__herbertboland__mouthpop.wav"];
						if ([slingerComponent loadedBeeType] == [BeeType SPEEDEE])
						{
							[[SoundManager sharedManager] playSound:@"SpeedeeSling"];
						}
						
						[slingerComponent clearLoadedBee];
						
						[trajectoryComponent reset];
						
						BeeComponent *beeComponent = [BeeComponent getFrom:beeEntity];
						RenderComponent *beeRenderComponent = [RenderComponent getFrom:beeEntity];
						NSString *shootAnimationName = [NSString stringWithFormat:@"%@-Shoot", [[beeComponent type] capitalizedString]];
						NSString *idleAnimationName = [NSString stringWithFormat:@"%@-Idle", [[beeComponent type] capitalizedString]];
						[beeRenderComponent playAnimationsLoopLast:[NSArray arrayWithObjects:shootAnimationName, idleAnimationName, nil]];
						
						// Game notification
						[[NSNotificationCenter defaultCenter] postNotificationName:GAME_NOTIFICATION_BEE_FIRED object:self];
						
						[_inputSystem clearInputActions];
					}
					
					[self stopShootingAimPollens];
					
					[slingerComponent setState:SLINGER_STATE_IDLE];
                }
                break;
            }
        }
    }
    
    [self shootAimPollens:trajectoryComponent];
}

-(float) calculateAimAngle:(CGPoint)touchLocation slingerLocation:(CGPoint)slingerLocation
{
	CGPoint slingerToStartVector = ccpSub(_startLocation, slingerLocation);
	CGPoint slingerToTouchVector = ccpSub(touchLocation, slingerLocation);
	
	float startAngle = ccpToAngle(slingerToStartVector);
	float touchAngle = ccpToAngle(slingerToTouchVector);
	float angleDifference = touchAngle - startAngle;
	float aimAngle = _currentAngle + SLINGER_AIM_SENSITIVITY * angleDifference;
	
	return aimAngle;
}

-(float) calculatePower:(CGPoint)touchLocation slingerLocation:(CGPoint)slingerLocation
{
	CGPoint slingerToStartVector = ccpSub(_startLocation, slingerLocation);
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
