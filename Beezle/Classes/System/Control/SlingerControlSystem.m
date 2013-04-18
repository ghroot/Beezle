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
#import "CDXPropertyModifierAction.h"

static const float SLINGER_POWER_SENSITIVITY = 5.0f;
static const int SLINGER_MIN_POWER = 100;
static const int SLINGER_MAX_POWER = 400;
static const int SLINGER_DEAD_DISTANCE = 15;
static const float SLINGER_STRETCH_SOUND_SCALE = 0.8f;
static const float SLINGER_HEIGHT = 28.0f;
static const float SCALE_AT_MIN_POWER = 0.9f;
static const float SCALE_AT_MAX_POWER = 0.5f;

@interface SlingerControlSystem()

-(float) calculateAimAngle:(CGPoint)touchLocation slingerLocation:(CGPoint)slingerLocation;
-(float) calculatePower:(CGPoint)touchLocation slingerLocation:(CGPoint)slingerLocation;
-(void) rotateToOriginalRotation:(Entity *)entity;
-(void) startBuzzSound;
-(void) stopBuzzSound;

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

	[_soundSource release];

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
			case TOUCH_MOVED:
			{
				if ([slingerComponent state] == SLINGER_STATE_IDLE)
				{
					if (ccpDistance([transformComponent position], [nextInputAction touchLocation]) <= 50.0f)
					{
						_stretchSoundPlayed = FALSE;

						[slingerComponent setState:SLINGER_STATE_AIMING];
					}
				}

				if ([slingerComponent state] == SLINGER_STATE_AIMING)
				{
					if (![slingerComponent hasLoadedBee])
					{
						[slingerComponent loadNextBee];

						// Game notification
						[[NSNotificationCenter defaultCenter] postNotificationName:GAME_NOTIFICATION_BEE_LOADED object:self];

						[self startBuzzSound];
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

					// Scale
					float percent = (power - SLINGER_MIN_POWER) / (SLINGER_MAX_POWER - SLINGER_MIN_POWER);
					float scale = SCALE_AT_MIN_POWER + percent * (SCALE_AT_MAX_POWER - SCALE_AT_MIN_POWER);
					RenderSprite *bodyRenderSprite = [renderComponent renderSpriteWithName:@"body"];
					[bodyRenderSprite setScale:CGPointMake(1.0f, scale)];
					RenderSprite *frontRenderSprite = [renderComponent renderSpriteWithName:@"front"];
					[frontRenderSprite setScale:CGPointMake(1.0f, scale)];
					RenderSprite *backRenderSprite = [renderComponent renderSpriteWithName:@"back"];
					[backRenderSprite setScale:CGPointMake(1.0f, (5 * (1.0f - scale)))];
					RenderSprite *addonRenderSprite = [renderComponent renderSpriteWithName:@"addon"];
					[addonRenderSprite setScale:CGPointMake(1.0f, (5 * (1.0f - scale)))];

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
			case TOUCH_CANCELLED:
			{
				if ([slingerComponent state] == SLINGER_STATE_AIMING)
				{
					if (![trajectoryComponent isZero])
					{
						// Create bee
						Entity *beeEntity = [EntityFactory createBee:_world withBeeType:[slingerComponent loadedBeeType] andVelocity:[trajectoryComponent startVelocity]];
						[EntityUtil setEntityPosition:beeEntity position:[trajectoryComponent startPoint]];
						[EntityUtil setEntityRotation:beeEntity rotation:[transformComponent rotation] + 90];

						RenderSprite *bodyRenderSprite = [renderComponent renderSpriteWithName:@"body"];
						[bodyRenderSprite setScale:CGPointMake(1.0f, 1.0f)];
						[bodyRenderSprite playAnimationsLoopLast:[NSArray arrayWithObjects:@"Slinger-Body-Shoot", @"Slinger-Body-Idle", nil]];
						RenderSprite *addonRenderSprite = [renderComponent renderSpriteWithName:@"addon"];
						[addonRenderSprite setScale:CGPointMake(1.0f, 0.1f)];
						RenderSprite *frontRenderSprite = [renderComponent renderSpriteWithName:@"front"];
						[frontRenderSprite setScale:CGPointMake(1.0f, 1.0f)];
						RenderSprite *backRenderSprite = [renderComponent renderSpriteWithName:@"back"];
						[backRenderSprite setScale:CGPointMake(1.0f, 0.1f)];

						[self stopBuzzSound];
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
		}
	}
}

-(float) calculateAimAngle:(CGPoint)touchLocation slingerLocation:(CGPoint)slingerLocation
{
	CGPoint touchToSlingerVector = ccpSub(slingerLocation, touchLocation);
	return ccpToAngle(touchToSlingerVector);
}

-(float) calculatePower:(CGPoint)touchLocation slingerLocation:(CGPoint)slingerLocation
{
	CGPoint touchToSlingerVector = ccpSub(slingerLocation, touchLocation);
	float touchToStartVectorLength = sqrtf(touchToSlingerVector.x * touchToSlingerVector.x + touchToSlingerVector.y * touchToSlingerVector.y);
	float power = SLINGER_POWER_SENSITIVITY * max(0.0f, touchToStartVectorLength - SLINGER_DEAD_DISTANCE);
	power = max(power, SLINGER_MIN_POWER);
	power = min(power, SLINGER_MAX_POWER);

	return power;
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

-(void) startBuzzSound
{
	NSString *soundFilePath = [[SoundManager sharedManager] soundFilePathForSfx:@"SlingerBzzz"];
	_soundSource = [[[SimpleAudioEngine sharedEngine] soundSourceForFile:soundFilePath] retain];
	[_soundSource setLooping:TRUE];
	[_soundSource setGain:0.0f];
	[_soundSource play];

	[CDXPropertyModifierAction fadeSoundEffect:1.0f finalVolume:1.0f curveType:kIT_Linear shouldStop:FALSE effect:_soundSource];
}

-(void) stopBuzzSound
{
	[[[CCDirector sharedDirector] actionManager] removeAllActionsFromTarget:_soundSource];
	[_soundSource stop];
	[_soundSource release];
	_soundSource = nil;
}

@end
