//
//  DragSystem.m
//  Beezle
//
//  Created by Me on 13/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SlingerControlSystem.h"
#import "EntityFactory.h"
#import "InputAction.h"
#import "InputSystem.h"
#import "RenderComponent.h"
#import "SimpleAudioEngine.h"
#import "TransformComponent.h"

#define SLINGER_POWER_SENSITIVITY 5.0
#define SLINGER_MIN_POWER 150.0
#define SLINGER_MAX_POWER 350.0
#define SLINGER_AIM_SENSITIVITY 3.0

@interface SlingerControlSystem()

-(float) calculateAimAngle:(CGPoint)touchLocation slingerLocation:(CGPoint)slingerLocation;
-(float) calculatePower:(CGPoint)touchLocation slingerLocation:(CGPoint)slingerLocation;

@end

@implementation SlingerControlSystem

@synthesize startLocation;

-(id) init
{
    if (self = [super initWithTag:@"SLINGER"])
	{
		_lastBeeType = BEE_TYPE_NONE;
	}
    return self;
}

-(void) processTaggedEntity:(Entity *)entity
{
    InputSystem *inputSystem = (InputSystem *)[[_world systemManager] getSystem:[InputSystem class]];
    if ([inputSystem hasInputActions])
    {
        InputAction *nextInputAction = [inputSystem popInputAction];
        
        TransformComponent *transformComponent = (TransformComponent *)[entity getComponent:[TransformComponent class]];
        RenderComponent *renderComponent = (RenderComponent *)[entity getComponent:[RenderComponent class]];
        
        switch ([nextInputAction touchType])
        {
            case TOUCH_START:
            {
                [self setStartLocation:[nextInputAction touchLocation]];
                break;
            }
            case TOUCH_MOVE:
            {
				float aimAngle = [self calculateAimAngle:[nextInputAction touchLocation] slingerLocation:[transformComponent position]];
				float power = [self calculatePower:[nextInputAction touchLocation] slingerLocation:[transformComponent position]];
                
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
            case TOUCH_END:
            {
				// TEMP: Set next bee type
                BeeType nextBeeType = BEE_TYPE_NONE;
				if (_lastBeeType == BEE_TYPE_NONE)
				{
					nextBeeType = BEE_TYPE_BEE;
				}
				else if (_lastBeeType == BEE_TYPE_BEE)
				{
					nextBeeType = BEE_TYPE_SAWEE;
				}
				else if (_lastBeeType == BEE_TYPE_SAWEE)
				{
					nextBeeType = BEE_TYPE_SPEEDEE;
				}
				else if (_lastBeeType == BEE_TYPE_SPEEDEE)
				{
					nextBeeType = BEE_TYPE_BOMBEE;
				}
				else if (_lastBeeType == BEE_TYPE_BOMBEE)
				{
					nextBeeType = BEE_TYPE_BEE;
				}
                _lastBeeType = nextBeeType;
				
				float aimAngle = [self calculateAimAngle:[nextInputAction touchLocation] slingerLocation:[transformComponent position]];
				float power = [self calculatePower:[nextInputAction touchLocation] slingerLocation:[transformComponent position]];
                CGPoint beeVelocity = CGPointMake(cosf(aimAngle) * power, sinf(aimAngle) * power);
                [EntityFactory createBee:_world type:nextBeeType withPosition:[transformComponent position] andVelocity:beeVelocity];
                
                [renderComponent playAnimationsLoopLast:[NSArray arrayWithObjects:@"Sling-Shoot", @"Sling-Idle", nil]];
                
                [[SimpleAudioEngine sharedEngine] playEffect:@"33369__herbertboland__mouthpop.wav"];
                
                break;
            }
        }
    }
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

@end
