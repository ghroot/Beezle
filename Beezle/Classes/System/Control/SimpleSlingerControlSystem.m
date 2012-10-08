//
//  SimpleSlingerControlSystem.m
//  Beezle
//
//  Created by Me on 13/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SimpleSlingerControlSystem.h"
#import "BeeComponent.h"
#import "EntityFactory.h"
#import "EntityUtil.h"
#import "NotificationTypes.h"
#import "InputAction.h"
#import "InputSystem.h"
#import "RenderComponent.h"
#import "RenderSprite.h"
#import "SlingerComponent.h"
#import "SoundManager.h"
#import "TrajectoryComponent.h"
#import "TransformComponent.h"
#import "Utils.h"

static const float SLINGER_POWER_SENSITIVITY = 7.5f;
static const int SLINGER_MIN_POWER = 100;
static const int SLINGER_MAX_POWER = 400;
static const float SLINGER_AIM_SENSITIVITY = 7.0f;
static const float SLINGER_STRETCH_SOUND_SCALE = 0.8f;
static const float SLINGER_HEIGHT = 28.0f;
static const float SCALE_AT_MIN_POWER = 1.0f;
static const float SCALE_AT_MAX_POWER = 0.5f;
static const int SLINGER_MAX_TOUCH_DISTANCE_FOR_SHOT = 9;
static const float SLINGER_MAX_TOUCH_TIME_FOR_SHOT = 0.3f;

@interface SimpleSlingerControlSystem ()

-(float) calculateAimAngle:(CGPoint)touchLocation slingerLocation:(CGPoint)slingerLocation;
-(float) calculatePower:(CGPoint)touchLocation slingerLocation:(CGPoint)slingerLocation;

@end

@implementation SimpleSlingerControlSystem

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
	SlingerComponent *slingerComponent = [SlingerComponent getFrom:entity];
	TransformComponent *transformComponent = [TransformComponent getFrom:entity];
	RenderComponent *renderComponent = [RenderComponent getFrom:entity];
	
    while ([_inputSystem hasInputActions])
    {
        InputAction *nextInputAction = [_inputSystem popInputAction];
        switch ([nextInputAction touchType])
        {
            case TOUCH_BEGAN:
            {
				if ([slingerComponent state] == SLINGER_STATE_IDLE)
				{
					_startLocation = [nextInputAction touchLocation];
                    _startAngle = [transformComponent rotation];
					_currentAngle = CC_DEGREES_TO_RADIANS(360 - [transformComponent rotation] + 270);
					_startPower = _currentPower;
					_touchBeganTime = [[NSDate date] timeIntervalSince1970];

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
					_currentPower = power;
					float modifiedPower = power * [[slingerComponent loadedBeeType] slingerShootSpeedModifier];

					// Trajectory
					CGPoint slingerTipVector = CGPointMake(cosf(aimAngle) * SLINGER_HEIGHT, sinf(aimAngle) * SLINGER_HEIGHT);
					CGPoint tipPosition = CGPointMake([transformComponent position].x + slingerTipVector.x, [transformComponent position].y + slingerTipVector.y);
					[trajectoryComponent setStartPoint:tipPosition];
					[trajectoryComponent setAngle:aimAngle];
					[trajectoryComponent setPower:modifiedPower];
					
					// Rotation
					float compatibleAimAngle = [Utils chipmunkRadiansToCocos2dDegrees:aimAngle];
					[transformComponent setRotation:compatibleAimAngle];
					
					// Strech scale
					float percent = (power - SLINGER_MIN_POWER) / (SLINGER_MAX_POWER - SLINGER_MIN_POWER);
					float scale = SCALE_AT_MIN_POWER + percent * (SCALE_AT_MAX_POWER - SCALE_AT_MIN_POWER);
                    RenderSprite *mainRenderSprite = [renderComponent renderSpriteWithName:@"main"];
                    [mainRenderSprite setScale:CGPointMake(1.0f, scale)];
                    RenderSprite *addonRenderSprite = [renderComponent renderSpriteWithName:@"addon"];
                    [addonRenderSprite setScale:CGPointMake(1.0f, (2 * (1.0f - scale)))];
					
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
					NSTimeInterval touchEndedTime = [[NSDate date] timeIntervalSince1970];
					if (ccpDistance(_startLocation, [nextInputAction touchLocation]) <= SLINGER_MAX_TOUCH_DISTANCE_FOR_SHOT &&
							touchEndedTime - _touchBeganTime <= SLINGER_MAX_TOUCH_TIME_FOR_SHOT &&
							![trajectoryComponent isZero])
					{
						// Create bee
						Entity *beeEntity = [EntityFactory createBee:_world withBeeType:[slingerComponent loadedBeeType] andVelocity:[trajectoryComponent startVelocity]];
						[EntityUtil setEntityPosition:beeEntity position:[trajectoryComponent startPoint]];
						[EntityUtil setEntityRotation:beeEntity rotation:[transformComponent rotation] + 90];

						RenderSprite *mainRenderSprite = [renderComponent renderSpriteWithName:@"main"];
						[mainRenderSprite setScale:CGPointMake(1.0f, 1.0f)];
						NSString *slingShootAnimationName = ccpLength([trajectoryComponent startVelocity]) >= 100.0f ? @"Sling-Shoot-Fast" : @"Sling-Shoot-Slow";
						[mainRenderSprite playAnimationsLoopLast:[NSArray arrayWithObjects:slingShootAnimationName, @"Sling-Idle", nil]];
						RenderSprite *addonRenderSprite = [renderComponent renderSpriteWithName:@"addon"];
						[addonRenderSprite setScale:CGPointMake(1.0f, 0.1f)];

						[[SoundManager sharedManager] playSound:@"SlingerShoot"];

						if ([[slingerComponent loadedBeeType] shootSoundName] != nil)
						{
							[[SoundManager sharedManager] playSound:[[slingerComponent loadedBeeType] shootSoundName]];
						}

						[slingerComponent clearLoadedBee];

						[trajectoryComponent reset];

						BeeComponent *beeComponent = [BeeComponent getFrom:beeEntity];
						RenderComponent *beeRenderComponent = [RenderComponent getFrom:beeEntity];
						NSString *shootAnimationName = [NSString stringWithFormat:@"%@-Shoot", [[beeComponent type] capitalizedString]];
						NSString *idleAnimationName = [NSString stringWithFormat:@"%@-Idle", [[beeComponent type] capitalizedString]];
						RenderSprite *beeDefaultRenderSprite = [beeRenderComponent defaultRenderSprite];
						[beeDefaultRenderSprite playAnimationsLoopLast:[NSArray arrayWithObjects:shootAnimationName, idleAnimationName, nil]];

						// Game notification
						[[NSNotificationCenter defaultCenter] postNotificationName:GAME_NOTIFICATION_BEE_FIRED object:self];

						[_inputSystem clearInputActions];
					}

					[[SoundManager sharedManager] stopSound:@"SlingerStretch"];

					[slingerComponent setState:SLINGER_STATE_IDLE];
                }
                break;
            }
            case TOUCH_CANCELLED:
            {
				if ([slingerComponent state] == SLINGER_STATE_AIMING)
                {
                    [_inputSystem clearInputActions];
                    [slingerComponent setState:SLINGER_STATE_IDLE];
                }
                break;
            }
        }
    }
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
	float power = _startPower + SLINGER_POWER_SENSITIVITY * vectorLengthDifference;
	power = max(power, SLINGER_MIN_POWER);
	power = min(power, SLINGER_MAX_POWER);
	
	return power;
}

@end
