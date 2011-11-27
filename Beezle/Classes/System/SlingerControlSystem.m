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
#import "TransformComponent.h"

@implementation SlingerControlSystem

@synthesize startLocation;

-(id) init
{
    self = [super initWithTag:@"SLINGER"];
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
                CGPoint slingerToTouchVector = ccpSub([nextInputAction touchLocation], [transformComponent position]);
                CGPoint slingerToStartVector = ccpSub([self startLocation], [transformComponent position]);
                
                float angle = CC_RADIANS_TO_DEGREES(ccpToAngle(slingerToTouchVector));
                angle = 360 - angle + 90 + 180;
                [transformComponent setRotation:angle];
                
                float slingerToStartVectorLength = sqrtf(slingerToStartVector.x * slingerToStartVector.x + slingerToStartVector.y * slingerToStartVector.y);
                float slingerToTouchVectorLength = sqrtf(slingerToTouchVector.x * slingerToTouchVector.x + slingerToTouchVector.y * slingerToTouchVector.y);
                float vectorLengthDifference = slingerToTouchVectorLength - slingerToStartVectorLength;
                if (vectorLengthDifference < 0)
                {
                    vectorLengthDifference = 0;
                }
                int stretchLevelDistance = 40;
                NSString *strechAnimationName;
                if (vectorLengthDifference < stretchLevelDistance)
                {
                    strechAnimationName = @"stretch1";
                }
                else if (vectorLengthDifference < 2 * stretchLevelDistance)
                {
                    strechAnimationName = @"stretch2";
                }
                else if (vectorLengthDifference < 3 * stretchLevelDistance)
                {
                    strechAnimationName = @"stretch3";
                }
                else
                {
                    strechAnimationName = @"stretch4";
                }
                [renderComponent playAnimation:strechAnimationName withLoops:1];
                
                break;
            }
            case TOUCH_END:
            {
                CGPoint slingerToTouchVector = ccpSub([nextInputAction touchLocation], [transformComponent position]);
                
                [renderComponent playAnimation:@"shoot" withLoops:1];
                
                CGPoint beeVelocity = CGPointMake(30 + 1.2 * slingerToTouchVector.x, 30 + 1.2 * slingerToTouchVector.y);
                Entity *beeEntity = [EntityFactory createBee:_world withPosition:[transformComponent position] andVelocity:beeVelocity];
                RenderComponent *beeRenderComponent = (RenderComponent *)[beeEntity getComponent:[RenderComponent class]];
                [beeRenderComponent playAnimation:@"fly" withLoops:1];
                
                break;
            }
        }
    }
}

@end
