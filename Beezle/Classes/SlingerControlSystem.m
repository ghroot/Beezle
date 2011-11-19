//
//  DragSystem.m
//  Beezle
//
//  Created by Me on 13/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SlingerControlSystem.h"

#import "cocos2d.h"

#import "TransformComponent.h"
#import "InputSystem.h"
#import "World.h"
#import "EntityFactory.h"

@implementation SlingerControlSystem

@synthesize startLocation;

-(id) init
{
    self = [super initWithUsedComponentClasses:[NSArray arrayWithObjects:[TransformComponent class], nil]];
    return self;
}

-(void) begin
{
    InputSystem *inputSystem = (InputSystem *)[[_world systemManager] getSystem:[InputSystem class]];
    if ([inputSystem hasInputActions])
    {
        InputAction *nextInputAction = [inputSystem peekInputAction];
        if ([nextInputAction touchType] == TOUCH_START)
        {
            [self setStartLocation:[nextInputAction touchLocation]];
        }
    }
}

-(void) processEntities:(NSArray *)entities
{
    Entity *slingerEntity = [[_world tagManager] getEntity:@"SLINGER"];
    [self processEntity:slingerEntity];
}

-(void) processEntity:(Entity *)entity
{
    InputSystem *inputSystem = (InputSystem *)[[_world systemManager] getSystem:[InputSystem class]];
    if ([inputSystem hasInputActions])
    {
        InputAction *nextInputAction = [inputSystem popInputAction];
        
        TransformComponent *transformComponent = (TransformComponent *)[entity getComponent:[TransformComponent class]];
        
        switch ([nextInputAction touchType])
        {
            case TOUCH_START:
            {
                break;
            }
            case TOUCH_MOVE:
            {
                CGPoint touchVector = ccpSub([nextInputAction touchLocation], [self startLocation]);
                
                float angle = CC_RADIANS_TO_DEGREES(ccpToAngle(touchVector));
                angle = 360 - angle + 90;
                [transformComponent setRotation:angle];
                
                float touchVectorLength = sqrtf(touchVector.x * touchVector.x + touchVector.y * touchVector.y);
                [transformComponent setScale:CGPointMake(1.0f, 1.0f + touchVectorLength / 100)];
                
                break;
            }
            case TOUCH_END:
            {
                [transformComponent setScale:CGPointMake(1.0f, 1.0f)];
                
                CGPoint touchVector = ccpSub([nextInputAction touchLocation], [self startLocation]);
                CGPoint beeVelocity = CGPointMake(1.5 * -touchVector.x, 1.5 * -touchVector.y);
                [EntityFactory createBee:_world withPosition:[transformComponent position] andVelocity:beeVelocity];
                
                break;
            }
        }
    }
}

@end
