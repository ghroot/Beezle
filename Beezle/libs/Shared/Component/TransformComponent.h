//
//  TransformBehaviour.h
//  Beezle
//
//  Created by Me on 07/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "artemis.h"

/**
  Has a position in the world.
 */
@interface TransformComponent : Component
{
    // Type / Instance
    CGPoint _scale;
    
    // Instance
    CGPoint _position;
    float _rotation;
}

@property (nonatomic) CGPoint scale;
@property (nonatomic) CGPoint position;
@property (nonatomic) float rotation;

@end
