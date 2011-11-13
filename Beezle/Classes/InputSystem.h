//
//  InputSystem.h
//  Beezle
//
//  Created by Me on 10/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EntitySystem.h"

typedef enum
{
    TOUCH_START,
    TOUCH_MOVE,
    TOUCH_END,
} touchTypes;

@interface InputSystem : EntitySystem
{
    int _touchType;
    CGPoint _touchLocation;
}

@property (nonatomic) int touchType;
@property (nonatomic) CGPoint touchLocation;

@end
