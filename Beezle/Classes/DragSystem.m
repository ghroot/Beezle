//
//  DragSystem.m
//  Beezle
//
//  Created by Me on 13/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DragSystem.h"

#import "cocos2d.h"

#import "DragComponent.h"
#import "TransformComponent.h"
#import "InputSystem.h"
#import "World.h"

@implementation DragSystem

@synthesize startLocation;

-(id) init
{
    if (self = [super initWithUsedComponentClasses:[NSMutableArray arrayWithObjects:[TransformComponent class], [DragComponent class], nil]])
    {   

    }
    return self;
}

-(void) begin
{
    InputSystem *inputSystem = (InputSystem *)[[_world systemManager] getSystem:[InputSystem class]];
    if ([inputSystem touchType] == TOUCH_START)
    {
        [self setStartLocation:[inputSystem touchLocation]];
    }
}

-(void) processEntity:(Entity *)entity
{
    InputSystem *inputSystem = (InputSystem *)[[_world systemManager] getSystem:[InputSystem class]];
    
    TransformComponent *transformComponent = (TransformComponent *)[entity getComponent:[TransformComponent class]];
    DragComponent *dragComponent = (DragComponent *)[entity getComponent:[DragComponent class]];
    
    switch ([inputSystem touchType])
    {
        case TOUCH_START:
        {
            [dragComponent setDragStartLocation:[transformComponent position]];
            break;
        }
        case TOUCH_MOVE:
        {
            CGPoint touchVector = ccpSub([inputSystem touchLocation], [self startLocation]);
            
            if ([dragComponent scale] > 0)
            {
                touchVector.x *= [dragComponent scale];
                touchVector.y *= [dragComponent scale];
                CGPoint newLocation = ccpAdd([dragComponent dragStartLocation], touchVector);
                [transformComponent setPosition:newLocation];
            }
            
            // TEMP
            float angle = CC_RADIANS_TO_DEGREES(ccpToAngle(touchVector));
            angle = 360 - angle + 90;
            [transformComponent setRotation:angle];
            
            // TEMP
            float touchVectorLength = sqrtf(touchVector.x * touchVector.x + touchVector.y * touchVector.y);
            [transformComponent setScale:CGPointMake(1.0f, 1.0f + touchVectorLength / 100)];
            
            break;
        }
        case TOUCH_END:
        {
            [transformComponent setPosition:[dragComponent dragStartLocation]];
            
            // TEMP
//            [transformComponent setRotation:0];
            
            // TEMP
            [transformComponent setScale:CGPointMake(1.0f, 1.0f)];
            
            break;
        }
    }
}

@end
