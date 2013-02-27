//
//  SlingerControlSystem
//  Beezle
//
//  Created by marcus on 08/10/2012.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SlingerControlSystem.h"
#import "SlingerComponent.h"
#import "InputSystem.h"
#import "TransformComponent.h"
#import "TrajectoryComponent.h"
#import "RenderComponent.h"
#import "PlayerInformation.h"
#import "SoundManager.h"
#import "TouchTypes.h"
#import "EntityFactory.h"
#import "EntityUtil.h"
#import "InputAction.h"
#import "NotificationTypes.h"
#import "Utils.h"
#import "RenderSprite.h"
#import "BeeComponent.h"
#import "RenderSystem.h"
#import "SlingerRotator.h"
#import "ActionTags.h"

static const float SLINGER_POWER_SENSITIVITY = 7.5f;
static const int SLINGER_MIN_POWER = 100;
static const int SLINGER_MAX_POWER = 400;
static const float SLINGER_AIM_SENSITIVITY = 7.0f;
static const float SLINGER_STRETCH_SOUND_SCALE = 0.8f;
static const float SLINGER_HEIGHT = 28.0f;
static const float SCALE_AT_MIN_POWER = 1.0f;
static const float SCALE_AT_MAX_POWER = 0.5f;
static const int SLINGER_MAX_TOUCH_DISTANCE_FOR_SHOT = 15;
static const float SLINGER_MAX_TOUCH_TIME_FOR_SHOT = 0.3f;
static const int SLINGER_MAX_TOUCH_DISTANCE_FOR_SETTING_CHANGE = 40;

@interface SlingerControlSystem()

-(void) processEntitySimple:(Entity *)entity;
-(void) processEntityAdvanced:(Entity *)entity;
-(float) calculateAimAngle:(CGPoint)touchLocation slingerLocation:(CGPoint)slingerLocation;
-(float) calculatePower:(CGPoint)touchLocation slingerLocation:(CGPoint)slingerLocation;
-(void) changeToSimpleMode:(Entity *)entity;
-(void) changeToAdvancedMode:(Entity *)entity;
-(void) createControlChangeText:(Entity *)entity fileName:(NSString *)fileName;
-(void) rotateToOriginalRotation:(Entity *)entity;

@end

@implementation SlingerControlSystem

-(id) init
{
	self = [super initWithUsedComponentClasses:[NSArray arrayWithObject:[SlingerComponent class]]];
	return self;
}

-(void) dealloc
{
	[_transformComponentMapper release];
	[_trajectoryComponentMapper release];
	[_slingerComponentMapper release];
	[_renderComponentMapper release];

	[super dealloc];
}

-(void) initialise
{
	_inputSystem = (InputSystem *)[[_world systemManager] getSystem:[InputSystem class]];
	_renderSystem = (RenderSystem *)[[_world systemManager] getSystem:[RenderSystem class]];

	_transformComponentMapper = [[ComponentMapper alloc] initWithEntityManager:[_world entityManager] componentClass:[TransformComponent class]];
	_trajectoryComponentMapper = [[ComponentMapper alloc] initWithEntityManager:[_world entityManager] componentClass:[TrajectoryComponent class]];
	_slingerComponentMapper = [[ComponentMapper alloc] initWithEntityManager:[_world entityManager] componentClass:[SlingerComponent class]];
	_renderComponentMapper = [[ComponentMapper alloc] initWithEntityManager:[_world entityManager] componentClass:[RenderComponent class]];
}

-(void) entityAdded:(Entity *)entity
{
	SlingerComponent *slingerComponent = [SlingerComponent getFrom:entity];
	[slingerComponent setState:SLINGER_STATE_IDLE];

	TransformComponent *transformComponent = [_transformComponentMapper getComponentFor:entity];
	[slingerComponent setOriginalRotation:[transformComponent rotation]];
	SlingerRotator *rotator = [[[SlingerRotator alloc] initWithSlingerEntity:entity] autorelease];
	[slingerComponent setRotator:rotator];
}

-(void) processEntity:(Entity *)entity
{
	if ([[PlayerInformation sharedInformation] usingAdvancedControlScheme])
	{
		[self processEntityAdvanced:entity];
	}
	else
	{
		[self processEntitySimple:entity];
	}
}

-(void) processEntitySimple:(Entity *)entity
{
	TrajectoryComponent *trajectoryComponent = [_trajectoryComponentMapper getComponentFor:entity];
	SlingerComponent *slingerComponent = [_slingerComponentMapper getComponentFor:entity];
	TransformComponent *transformComponent = [_transformComponentMapper getComponentFor:entity];
	RenderComponent *renderComponent = [_renderComponentMapper getComponentFor:entity];

	while ([_inputSystem hasInputActions])
	{
		InputAction *nextInputAction = [_inputSystem popInputAction];
		switch ([nextInputAction touchType])
		{
			case TOUCH_BEGAN:
			{
				if ([slingerComponent state] == SLINGER_STATE_IDLE)
				{
					if ([trajectoryComponent isZero] &&
							ccpDistance([transformComponent position], [nextInputAction touchLocation]) <= SLINGER_MAX_TOUCH_DISTANCE_FOR_SETTING_CHANGE)
					{
						[self changeToAdvancedMode:entity];
					}
					else
					{
						_startLocation = [nextInputAction touchLocation];
						_startAngle = [transformComponent rotation];
						_currentAngle = CC_DEGREES_TO_RADIANS(360 - [transformComponent rotation] + 270);
						_startPower = _currentPower;
						_touchBeganTime = [[NSDate date] timeIntervalSince1970];

						_stretchSoundPlayed = FALSE;

						[[[CCDirector sharedDirector] actionManager] removeActionByTag:ACTION_TAG_SLINGER_ROTATION target:[slingerComponent rotator]];

						[slingerComponent setState:SLINGER_STATE_AIMING];
					}
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

						_currentPower = 0.0f;
						_startPower = 0.0f;

						[trajectoryComponent reset];

						[self rotateToOriginalRotation:entity];

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

					[[SoundManager sharedManager] stopSound:@"SlingerStretch"];

					[slingerComponent setState:SLINGER_STATE_IDLE];
				}
				break;
			}
		}
	}
}

-(void) processEntityAdvanced:(Entity *)entity
{
	TrajectoryComponent *trajectoryComponent = [_trajectoryComponentMapper getComponentFor:entity];
	SlingerComponent *slingerComponent = [_slingerComponentMapper getComponentFor:entity];
	TransformComponent *transformComponent = [_transformComponentMapper getComponentFor:entity];
	RenderComponent *renderComponent = [_renderComponentMapper getComponentFor:entity];

	while ([_inputSystem hasInputActions])
	{
		InputAction *nextInputAction = [_inputSystem popInputAction];
		switch ([nextInputAction touchType])
		{
			case TOUCH_BEGAN:
			{
				if ([slingerComponent state] == SLINGER_STATE_IDLE)
				{
					if ([trajectoryComponent isZero] &&
							ccpDistance([transformComponent position], [nextInputAction touchLocation]) <= SLINGER_MAX_TOUCH_DISTANCE_FOR_SETTING_CHANGE)
					{
						[self changeToSimpleMode:entity];
					}
					else
					{
						_startLocation = [nextInputAction touchLocation];
						_startAngle = [transformComponent rotation];
						_currentAngle = CC_DEGREES_TO_RADIANS(360 - [transformComponent rotation] + 270);

						_stretchSoundPlayed = FALSE;

						[[[CCDirector sharedDirector] actionManager] removeActionByTag:ACTION_TAG_SLINGER_ROTATION target:[slingerComponent rotator]];

						[slingerComponent setState:SLINGER_STATE_AIMING];
					}
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
					if (![trajectoryComponent isZero])
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

						[[SoundManager sharedManager] stopSound:@"SlingerStretch"];
						[[SoundManager sharedManager] playSound:@"SlingerShoot"];

						if ([[slingerComponent loadedBeeType] shootSoundName] != nil)
						{
							[[SoundManager sharedManager] playSound:[[slingerComponent loadedBeeType] shootSoundName]];
						}

						[slingerComponent clearLoadedBee];

						[trajectoryComponent reset];

						[self rotateToOriginalRotation:entity];

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

					[slingerComponent setState:SLINGER_STATE_IDLE];
				}
				break;
			}
			case TOUCH_CANCELLED:
			{
				if ([slingerComponent hasLoadedBee])
				{
					RenderSprite *mainRenderSprite = [renderComponent renderSpriteWithName:@"main"];
					[mainRenderSprite setScale:CGPointMake(1.0f, 1.0f)];
					RenderSprite *addonRenderSprite = [renderComponent renderSpriteWithName:@"addon"];
					[addonRenderSprite setScale:CGPointMake(1.0f, 0.1f)];

					[transformComponent setRotation:_startAngle];

					[[SoundManager sharedManager] stopSound:@"SlingerStretch"];

					[slingerComponent revertLoadedBee];

					[trajectoryComponent reset];

					// Game notification
					[[NSNotificationCenter defaultCenter] postNotificationName:GAME_NOTIFICATION_BEE_REVERTED object:self];

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

-(void) changeToSimpleMode:(Entity *)entity
{
	[_inputSystem clearInputActions];

	[[PlayerInformation sharedInformation] setUsingAdvancedControlScheme:FALSE];
	[[PlayerInformation sharedInformation] save];

	[self createControlChangeText:entity fileName:@"Text-TapToShoot.png"];

	[[SoundManager sharedManager] playSound:@"PollenCollect"];
}

-(void) changeToAdvancedMode:(Entity *)entity
{
	[_inputSystem clearInputActions];

	[[PlayerInformation sharedInformation] setUsingAdvancedControlScheme:TRUE];
	[[PlayerInformation sharedInformation] save];

	[self createControlChangeText:entity fileName:@"Text-ReleaseToShoot.png"];

	[[SoundManager sharedManager] playSound:@"PollenCollect"];
}

-(void) createControlChangeText:(Entity *)entity fileName:(NSString *)fileName
{
	TransformComponent *transformComponent = [_transformComponentMapper getComponentFor:entity];

	if (_controlChangeTextSprite != nil)
	{
		[[_renderSystem layer] removeChild:_controlChangeTextSprite cleanup:TRUE];
		[_controlChangeTextSprite release];
		_controlChangeTextSprite = nil;
	}

	_controlChangeTextSprite = [[CCSprite alloc] initWithFile:fileName];
	float textX = max(65.0f, [transformComponent position].x);
	[_controlChangeTextSprite setPosition:CGPointMake(textX, [transformComponent position].y)];
	[[_renderSystem layer] addChild:_controlChangeTextSprite z:200];

	id moveUpAction = [CCEaseSineOut actionWithAction:[CCMoveBy actionWithDuration:1.5f position:CGPointMake(0.0f, 20.0f)]];
	id fadeOutAction = [CCEaseSineIn actionWithAction:[CCFadeOut actionWithDuration:3.0f]];
	id removeAction = [CCCallBlock actionWithBlock:^{
		[[_renderSystem layer] removeChild:_controlChangeTextSprite cleanup:TRUE];
		[_controlChangeTextSprite release];
		_controlChangeTextSprite = nil;
	}];
	[_controlChangeTextSprite runAction:moveUpAction];
	[_controlChangeTextSprite runAction:[CCSequence actionOne:fadeOutAction two:removeAction]];
}

-(void) rotateToOriginalRotation:(Entity *)entity
{
	SlingerComponent *slingerComponent = [_slingerComponentMapper getComponentFor:entity];
	TransformComponent *transformComponent = [_transformComponentMapper getComponentFor:entity];

	[[[CCDirector sharedDirector] actionManager] removeActionByTag:ACTION_TAG_SLINGER_ROTATION target:[slingerComponent rotator]];

	CCSequence *sequence = nil;

	CCDelayTime *delayAction = [CCDelayTime actionWithDuration:0.18f];

	if ([transformComponent rotation] < 180.0f - (360.0f - [slingerComponent originalRotation]))
	{
		float halfWayRotation = [slingerComponent originalRotation] + 20.0f - 360.0f;
		float degreesToRotate = fabsf([transformComponent rotation] - halfWayRotation);
		float duration = degreesToRotate / 600.0f;
		CCActionTween *tweenAction1 = [CCActionTween actionWithDuration:duration key:@"rotation" from:[transformComponent rotation] to:halfWayRotation];
		id tweenAction2 = [CCEaseElasticOut actionWithAction:[CCActionTween actionWithDuration:0.3f key:@"rotation" from:halfWayRotation to:[slingerComponent originalRotation] - 360.0f] period:0.2f];

		sequence = [CCSequence actions:delayAction, tweenAction1, tweenAction2, nil];
	}
	else
	{
		float halfWayRotation = [slingerComponent originalRotation] - 20.0f;
		float degreesToRotate = fabsf([transformComponent rotation] - halfWayRotation);
		float duration = degreesToRotate / 600.0f;
		CCActionTween *tweenAction1 = [CCActionTween actionWithDuration:duration key:@"rotation" from:[transformComponent rotation] to:halfWayRotation];
		id tweenAction2 = [CCEaseElasticOut actionWithAction:[CCActionTween actionWithDuration:0.3f key:@"rotation" from:halfWayRotation to:[slingerComponent originalRotation]] period:0.2f];

		sequence = [CCSequence actions:delayAction, tweenAction1, tweenAction2, nil];
	}
	[sequence setTag:ACTION_TAG_SLINGER_ROTATION];
	[[[CCDirector sharedDirector] actionManager] addAction:sequence target:[slingerComponent rotator] paused:FALSE];
}

-(void) reset:(Entity *)slingerEntity
{
	RenderComponent *renderComponent = [_renderComponentMapper getComponentFor:slingerEntity];
	RenderSprite *mainRenderSprite = [renderComponent renderSpriteWithName:@"main"];
	[mainRenderSprite setScale:CGPointMake(1.0f, 1.0f)];
	RenderSprite *addonRenderSprite = [renderComponent renderSpriteWithName:@"addon"];
	[addonRenderSprite setScale:CGPointMake(1.0f, 0.1f)];

	TransformComponent *transformComponent = [_transformComponentMapper getComponentFor:slingerEntity];
	SlingerComponent *slingerComponent = [SlingerComponent getFrom:slingerEntity];
	[transformComponent setRotation:[slingerComponent originalRotation]];

	TrajectoryComponent *trajectoryComponent = [_trajectoryComponentMapper getComponentFor:slingerEntity];
	[trajectoryComponent reset];

	_currentPower = 0.0f;
	_startPower = 0.0f;
}

@end
